// ::DEFINE
def image_name          = "gomicroservice"
def service_name        = "gomicroservice"
def repo_name           = "bobobox-assesment-test"
def unitTest_standard   = "80.0%"
def approval            = "imam.arief.rhmn@gmail.com"

// ::URL
def repo_url            = "https://github.com/greyhats13/${repo_name}.git"
// def lib_url             = "https://github.com/greyhats13/${repo_name}.git"
// def lib_url_auth        = "git@github.com:greyhats13/bobobox-assesment-test.git"
def ecr_url             = "dkr.ecr.ap-southeast-1.amazonaws.com"
def ecr_credentialsId   = "ecr:ap-southeast-1:awscredentials"
def helm_git            = "https://github.com/greyhats13/${repo_name}.git"
def artifact_url        = "http://nexus.bobobox.co.id/repository"
def spinnaker_webhook   = "http://spinnaker-login.bobobox.co.id/webhooks/${service_name}"
def automation_repo     = "https://github.com/greyhats13/${repo_name}.git"
def k6_repo             = "https://github.com/greyhats13/${repo_name}.git"

// ::NOTIFICATIONS
def telegram_url        = "https://api.telegram.org/botxxxxxx:xxxxxxxxxxxxx/sendMessage"
def telegram_chatid     = "-xxxxxx"
def slack_colour        = "#BADA55"
def slack_channel       = "#demo-channel"
def emails              = "imam.arief.rhmn@gmail.com"
def job_success         = "SUCCESS"
def job_error           = "ERROR"

// ::INITIALIZATION
def fullname            = "${service_name}-${env.BUILD_NUMBER}"
def version, helm_dir, runPipeline, unitTest_score

// ::POD-TEMPLATE
// Pod template setup for Jenkins slave should the CI/CD process is taking place.
podTemplate(
    label: fullname,
    containers: [
        //container template to perform docker build and docker push operation
        containerTemplate(name: 'docker', image: 'docker.io/docker', command: 'cat', ttyEnabled: true),
        //container template to perform helm command such as helm packaging
        containerTemplate(name: 'helm', image: 'docker.io/alpine/helm', command: 'cat', ttyEnabled: true),
        //container template to perform curl command
        containerTemplate(name: 'curl', image: 'centos', command: 'cat', ttyEnabled: true)
        //container template to perform performance test using k6
        containerTemplate(name: 'k6', image: 'coralspec/k6', command: 'cat', ttyEnabled: true)
    ],
    
    volumes: [
        //the mounting for container
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ]) {

    node(fullname) {
        try {
            // ::CHECKOUT
            stage("Checkout") {
                // ::TRIGGER
                //Choosewhich pipeline to run based on event trigger by aprameter and using branch
                if (env.GET_TRIGGER == 'staging') {
                    runPipeline = 'staging'
                    runBranch   = "origin/feature/*"
                } else if (env.GET_TRIGGER == 'production') {
                    runPipeline = 'production'
                    runBranch   = "*/*"
                } else {
                    runPipeline = 'dev'
                    runBranch   = "*/${env.BRANCH_NAME}"
                }

                // ::SOURCE CHECKOUT
                //checkout to define branch to Source Code Management
                def scm = checkout([$class: 'GitSCM', branches: [[name: runBranch]], userRemoteConfigs: [[credentialsId: 'github-auth-token', url: repo_url]]])

                // ::VERSIONING
                //Assign the version and helm directory based on chosen pipeline and branch
                
                //If the run pipeline is "dev" and the branch is "orivin/dev" run Dev pipeline
                if (runPipeline == 'dev' && scm.GIT_BRANCH == 'origin/dev') {
                    echo "Running Dev Pipeline with ${scm.GIT_BRANCH} branch"
                    version     = "alpha"
                    helm_dir    = "test"
                //If the run pipeline is "staging", run Staging pipeline
                } else if (runPipeline == 'staging') {
                    echo "Running Staging Pipeline with ${scm.GIT_BRANCH} branch"
                    version     = "beta"
                    helm_dir    = "incubator"
                //If the run pipeline is "production", run Production pipeline
                } else if (runPipeline == 'production') {
                    echo "Running Production Pipeline with tag ${scm.GIT_BRANCH}"
                    version     = "release"
                    helm_dir    = "stable"
                } else {
                    //If the run pipeline is not "dev" but the branch is "origin/debug", just run unit test and code review on dev pipeline
                    echo "Running Dev Pipeline with ${scm.GIT_BRANCH} branch"
                    version     = "debug"
                    helm_dir    = "test"
                }
            }

            // ::Dev-STAGING
            //Check if the version is realase or not.
            if (version != "release") {
                //if version not "release" run the Unit Test and Code Review
                stage("Unit Test") {                    
                    def golang = tool name: 'golang', type: 'go'
                    withEnv(["GOROOT=${golang}", "PATH+GO=${golang}/bin"]) {
                        echo "Running Unit Test"

                        // goEnv(lib_url: lib_url, lib_url_auth: lib_url_auth)

                        //Run Unit Test with throwable error
                        try {
                            unitTest()
                        } catch (e) {
                            echo "${e}"
                        }
                        //Get Unit Test value result.
                        def unitTestGetValue = sh(returnStdout: true, script: 'go tool cover -func=coverage.out | grep total | sed "s/[[:blank:]]*$//;s/.*[[:blank:]]//"')
                        unitTest_score = "Your score is ${unitTestGetValue}"
                        //Print Unit Test value result.
                        echo "${unitTest_score}"
                        //Checkk wheter unit test result value meet the unit test standard score
                        if (unitTestGetValue >= unitTest_standard){
                            //print the messages that 
                            echo "Unit Test met the standar value with score ${unitTestGetValue}/${unitTest_standard}"
                        } else {
                            //Abort the pipeline if unit test score didn't meet the unit test standard score
                            currentBuild.result = 'ABORTED'
                            error("Sorry, the unit test score didn't meet our standard score ${unitTestGetValue}/${unitTest_standard}")
                        }
                    }
                }
                //Code review stage
                stage("Code Review") {
                    echo "Running Code Review with SonarQube"
                    def scannerHome = tool "sonarscanner"
                    withSonarQubeEnv ("sonarserver") {
                        //Run SonarScanGo function to perform code review
                        sonarScanGo(scannerHome: scannerHome, project_name: fullname, image_name: image_name, project_version: "${version}")
                    }
                    //set the timeout to 10 minutes
                    timeout(time: 10, unit: 'MINUTES') {
                        //if timeout is triggered abort the pipeline
                        waitForQualityGate abortPipeline: true
                    }
                }

                // ::NONPROD-PIPELINE
                //if version is debug or production, dont run this pipeline stage
                if (version == 'alpha' || version == 'beta') {
                    //Enter artifactory stage
                    stage("Artifactory") {
                        //run container, helm chart, binary build and push artifactory in parallel
                        parallel(
                            //Enter container section to perform docker build and push to private registry
                            'Container': {
                                //enter build container stage
                                stage('Build Container') {
                                    //use container to run docker command
                                    container('docker') {
                                        //run docker build function
                                        dockerBuild(ecr_url: ecr_url, image_name: image_name, image_version: version)
                                    }
                                }
                                //enter push container stage
                                stage('Push Container') {
                                    //use docker container to run docker command
                                    container('docker') {
                                        docker.withRegistry("https://${ecr_url}", ecr_credentialsId) {
                                            // ::LATEST
                                            //run docker push function to push latest image
                                            dockerPush(ecr_url: ecr_url, image_name: image_name, image_version: version)
                                            // ::VERSION
                                            //run docker push tag to assign tagging version and build number
                                            dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: version, dstVersion: "${version}-${BUILD_NUMBER}")
                                            // ::REVERT
                                            //run docker push tag to assign tagging revert version
                                            if (version == 'beta') {
                                                dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: version, dstVersion: "${version}-revert")
                                            }
                                        }
                                    }
                                }
                            },
                            //Enter helm chart section to perform helm linting, helm dry run, and helm packaging
                            'Chart': {
                                //enter helm chart packaging stage
                                stage('Packaging') {
                                    //create helm directory
                                    sh "mkdir helm"
                                    //use helm container to run docker command
                                    container('helm') {
                                        //change directory to helm
                                        dir('helm') {
                                            //checkout to master branch of helm repository
                                            checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'github-auth-token', url: helm_git]]])
                                            //change directory to test, incubator, or stable
                                            dir(helm_dir) {
                                                //run helm linting function to perform syntax checking should any error is triggered
                                                helmLint(service_name)
                                                //run helmDryRun function to simulate deployment but not really deployed to cluster should any error is triggered in deployment
                                                helmDryRun(name: service_name, service_name: service_name)
                                                //run helmPackage function to compressed helm chart to .tgz format
                                                helmPackage(service_name)
                                            }
                                        }
                                    }
                                }
                                //enter helm chart push artifactory stage
                                stage('Push Chart') {
                                    echo "Push Chart to Artifactory"
                                    //use centos container to run curl command
                                    container('curl') {
                                        //change directory to helm
                                        dir("helm") {
                                            //change directory to test, incubator, or stable
                                            dir(helm_dir) {
                                                //run pushArtifact function to upload helm chart package to nexus
                                                pushArtifact(name: "helm", artifact_url: artifact_url, artifact_repo: helm_dir)
                                            }
                                        }
                                    }
                                }
                            },
                             //Enter Golang Binarys section to perform golang binary build and push to artifactory
                            'Binary': {
                                //enter build golang binary stage
                                stage('Build Binary') {
                                    def golang = tool name: 'golang', type: 'go'
                                    withEnv(["GOROOT=${golang}", "PATH+GO=${golang}/bin"]) {
                                        //perform golang environtment function
                                        goEnv (lib_url: lib_url, lib_url_auth: lib_url_auth)
                                        //perform golang binary build function
                                        goBuild (name : service_name)
                                        //perform golang binary build function with build number
                                        goBuild (name : "${service_name}-${BUILD_NUMBER}")
                                    }
                                }
                                //enter push golang binary stage
                                stage('Push Binary') {
                                    //perform golang pushArtifact function
                                    pushArtifact(name: service_name, artifact_url: artifact_url, artifact_repo: "gobinary")
                                    //perform golang pushArtifact function with build number
                                    pushArtifact(name: "${service_name}-${BUILD_NUMBER}", artifact_url: artifact_url, artifact_repo: "gobinary")
                                }
                            }
                        )
                    }
                } else {
                    echo "Sorry we can't continue. Because it's not Dev or Staging cluster"
                }
            } else {
                //if the version is "release" enter production pipeline
                // ::PRODUCTION
                //Enter update container stage
                stage("Update Container") {
                    //use container to run docker command
                    container('docker') {
                        //setup docker registry url and credentials
                        docker.withRegistry("https://${ecr_url}", ecr_credentialsId) {
                            // ::PROD LATEST TO REVERT
                            //perform dockerPull function to pull current prod latest docker image
                            dockerPull(ecr_url: ecr_url, image_name: image_name, image_version: version)
                            //perform dockerPushTag function to update current prod latest docker image to revert version. It is usefull to rollback should new deployment is failed in testing phase
                            dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: version, dstVersion: "${version}-revert")

                            // ::STAGING TO PROD LATEST
                            //perform dockerPull function to pull current staging(beta) latest docker image
                            dockerPull(ecr_url: ecr_url, image_name: image_name, image_version: "beta")
                            //perform dockerPushTag function to update current staging(beta) docker image to prod (release) latest version.
                            dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: "beta", dstVersion: version)
                        }
                    }
                }
            }

            // ::VERIFY-DEPLOYMENT
            //check the version, if the version is not alpha, beta, release there will be no deployment to cluster allowed
            if (version != "debug") {
                //enter deployment stage
                stage("Deployment") {
                    //run deploySpinnaker function to trigger Spinnaker deployment pipeline and get trigger back to Jenkins when deployment is done
                    deploySpinnaker(spinnaker_webhook: spinnaker_webhook, version: version)
                }
            } else {
                //print no deployment messages
                echo "Sorry, No Deployment"
            }

            // ::TESTING
            //Testing Section is running after deploynment to Staging cluster is succeed
            try {
                //Check if the version is beta because testing is only allowed in Staging pipeline
                if (version == "beta") {
                    stage ("Security Test") {
                        echo "Running Security Testing"
                        // CODE Not available yet
                    }
                    //enter performance test stage
                    stage ("Performance Test") {
                        //Run performance test using K6
                        echo "Running Performance Test"
                        // sh "mkdir performance"
                        // dir("performance") {
                        //     checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'github-auth-token', url: k6_repo]]])
                        //     container("k6") {
                        //         sh "k6 run ${service_name}.js"
                        //     }
                        // }
                    }
                     //enter automation test stage
                    stage ("Automation Test") {
                        //Run automation test using Newman (Postman) for API testing and Journey testing
                        echo "Running Automation Test"
                        // sh "mkdir autotest"
                        // dir("autotest") {
                        //     nodejs('nodejs') {
                        //         checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'github-auth-token', url: automation_repo]]])
                        //         try {
                        //             sh "npx jest -c journey.newman.js"
                        //         } catch (e) {
                        //             echo "${e}"
                        //         }
                        //     }
                        // }
                    }

                } else if (version == "release") {
                    try {
                        stage("Sanity Test") {
                            echo "Running Sanity Test"
                            // sh "mkdir sanity"
                            // dir("sanity") {
                            //     nodejs('nodejs') {
                            //         checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[credentialsId: 'github-auth-token', url: automation_repo]]])
                            //         try {
                            //             sh "newman run journey.json"
                            //         } catch (e) {
                            //             echo "${e}"
                            //         }
                            //     }
                            // }
                        }
                    } catch (e) {
                        //enter Revert production image version stage, this stage only run if security, automation or performance test is thrown an error which indicate the failure during testing.
                        stage("Revert Production") {
                            // ::REVERT Production
                            //use container for running docker command in production
                            container('docker') {
                                //setup ECR private registry url and credentials
                                docker.withRegistry("https://${ecr_url}", ecr_credentialsId) {
                                    //run dockerpull function to pull docker image revert version
                                    dockerPull(ecr_url: ecr_url, image_name: image_name, image_version: "${version}-revert")
                                    //run docker push tag function to update docker image revert version back to latest version
                                    dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: "${version}-revert", dstVersion: version)
                                }
                            }
                        }
                        //redeploy the services in production cluster using previous docker image version due to failing in testing
                        stage("Deployment") {
                            //run deploySpinnaker function to redeploy to production cluster
                            deploySpinnaker(spinnaker_webhook: spinnaker_webhook, version: version)
                        }
                    }
                } else {
                    echo "No test except staging or production"
                }

            } catch (e) {
                // ::REVERT STAGING
                 //enter revert previou merge stage
                stage("Revert Previous Merge") {
                    echo "Get Merge ID & Push Again"
                    // CODE HERE
                }
                //enter Revert staging image version stage, this stage only run if security, automation or performance test is thrown an error which indicate the failure during testing.
                stage("Revert Container") {
                    //use container for running docker command in staging
                    container('docker') {
                        //setup ECR private registry url and credentials
                        docker.withRegistry("https://${ecr_url}", ecr_credentialsId) {
                            //run dockerpull function to pull docker image revert version
                            dockerPull(ecr_url: ecr_url, image_name: image_name, image_version: "${version}-revert")
                            //run docker push tag function to update docker image revert version back to latest version
                            dockerPushTag(ecr_url: ecr_url, image_name: image_name, srcVersion: "${version}-revert", dstVersion: version)
                        }
                    }
                }
                //redeploy the services in staging cluster using previous docker image version due to failing in testing
                stage("Deployment") {
                    //run deploySpinnaker function to redeploy to staging cluster
                    deploySpinnaker(spinnaker_webhook: spinnaker_webhook, version: version)
                }
            }
        //enter notification stage
        stage("Notifications") {
            //run notifications function to notify the pipeline result
            notifications(telegram_url: telegram_url, telegram_chatid: telegram_chatid, slack_channel: slack_channel, slack_colour: slack_colour, emails: emails,
                job: env.JOB_NAME, job_numb: env.BUILD_NUMBER, job_url: env.BUILD_URL, job_status: job_success, unitTest_score: unitTest_score
            )
        }
        } catch (e) {
            stage("Error"){
                //run notifications function to notify the error in notification
                notifications(telegram_url: telegram_url, telegram_chatid: telegram_chatid, slack_channel: slack_channel, slack_colour: slack_colour, emails: emails,
                    job: env.JOB_NAME, job_numb: env.BUILD_NUMBER, job_url: env.BUILD_URL, job_status: job_error, unitTest_score: unitTest_score
                )
            }
        }
    }
}

//function to perform code review using sonarcube
def sonarScanGo(Map args) {
    sh "${args.scannerHome}/bin/sonar-scanner -X \
    -Dsonar.projectName=${args.project_name}\
    -Dsonar.projectKey=mcs:go:${args.image_name}\
    -Dsonar.projectVersion=${args.project_version}\
    -Dsonar.sources=. \
    -Dsonar.go.file.suffixes=.go \
    -Dsonar.tests=. \
    -Dsonar.test.inclusions=**/**_test.go \
    -Dsonar.test.exclusions=**/vendor/** \
    -Dsonar.sources.inclusions=**/**.go \
    -Dsonar.exclusions=**/**.xml \
    -Dsonar.go.exclusions=**/*_test.go,**/vendor/**,**/testdata \
    -Dsonar.tests.reportPaths=report-tests.out \
    -Dsonar.go.govet.reportPaths=report-vet.out \
    -Dsonar.go.coverage.reportPaths=coverage.out"
}

//function to perform goEnv
def goEnv(Map args) {
    sh "go env -w GOSUMDB=off"
    sh "go env -w CGO_ENABLED=0"
    sh "git config --global url.'${args.lib_url_auth}'.insteadOf '${args.lib_url}'"
}

//function to perform unit test on golang microservices
def unitTest() {
    sh "go vet > report-vet.out"
    sh "go test ./... -covermode=count -coverprofile coverage.out"
    sh "go tool cover -func=coverage.out"
}

//function to perform build golang binary
def goBuild(Map args) {
    sh "go build -o ${args.name}"
}

//function to perform docker build that is defined in dockerfile
def dockerBuild(Map args) {
    sh "docker build --network host -t ${args.ecr_url}/${args.image_name}:${args.image_version} ."
}

//function to perform docker push tag to private registry ECR
def dockerPushTag(Map args) {
    sh "docker tag ${args.ecr_url}/${args.image_name}:${args.srcVersion} ${args.ecr_url}/${args.image_name}:${args.dstVersion}"
    sh "docker push ${args.ecr_url}/${args.image_name}:${args.dstVersion}"
}

//function to perform docker push to Private Docker registry which is Elastic Container Registry
def dockerPush(Map args) {
    sh "docker push ${args.ecr_url}/${args.image_name}:${args.image_version}"
}

//function to perform docker push tag to private registry ECR
def dockerPull(Map args) {
    sh "docker pull ${args.ecr_url}/${args.image_name}:${args.image_version}"
}

//Function to perform helm linting to check any syntax error in helm chart
def helmLint(String service_name) {
    echo "Running helm lint"
    sh "helm lint ${service_name}"
}

//Function to perform helm dry run to simulate deployment but not really deploy to k8s.
def helmDryRun(Map args) {
    echo "Running dry-run deployment"
    sh "helm install --dry-run --debug ${args.name} ${args.service_name} -n demo"
}

//Function to perform helm package into compressed format .tgz
def helmPackage(String service_name) {
    echo "Running Helm Package"
    sh "helm package ${service_name}"
}

//Function to perform pushArtifact that will push helm chart tgz to private registry (nexus)
def pushArtifact(Map args) {
    echo "Upload to Artifactory Server"
    if (args.name == "helm") {
        sh "curl -v -n -u admin:admin123 -T *.tgz ${args.artifact_url}/${args.artifact_repo}/"        
    } else {
        sh "curl -v -n -u admin:admin123 -T ${args.name} ${args.artifact_url}/${args.artifact_repo}/"
    }
}

//function to deploy helm chart to spinnaker by triggering the spinnaker pipeline via webhook, and wait for the spinnaker to trigger jenkins back when deployment is done.
def deploySpinnaker(Map args) {
    def hook = registerWebhook()
    echo "Hi Spinnaker!"
    //trigger the spinnaker pipeline
    sh "curl ${args.spinnaker_webhook}-${args.version} -X POST -H 'content-type: application/json' -d '{ \"parameters\": { \"jenkins-url\": \"${hook.getURL()}\" }}'"
    //wait for webhook from spinnaker to jenkins that will indicate should the deployment is done.
    def data = waitForWebhook hook
    //Print the deployment result
    echo "Webhook called with data: ${data}"
}

//function to perform notification should the pipeline is either failed or success.
def notifications(Map args) {
    //formatting the messages that will be sent to notification channel
    def message = "CICD Pipeline ${args.job} ${args.job_status} with build ${args.job_numb} \n\n More info at: ${args.job_url} \n\n Unit Test: ${args.unitTest_score} \n\n Total Time : ${currentBuild.durationString}"
    //run the notification channel in parallel
    parallel(
        //telegeram section
        "Telegram": {
            //send telegram notification
            sh "curl -s -X POST ${args.telegram_url} -d chat_id=${args.telegram_chatid} -d text='${message}'"
        },
        "Slack": {
            //send slack notification
            //slackSend color: "${args.slack_colour}", message: "${message}", channel: "${args.slack_channel}"
        },
        "Email": {
            //send email notification
            //emailext body: "${message}", subject: "Jenkins Build ${args.job_status}: Job ${args.job}", to: "${args.emails}"
        }
    )
}