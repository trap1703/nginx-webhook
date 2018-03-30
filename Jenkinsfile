node {
    stage ('Cleaning') {
        deleteDir()
        git 'https://github.com/progressivesasha/nginx-webhook.git'
    }
    stage ('Create container') {
        docker.withRegistry('https://registry.hub.docker.com/u/qatsi/nginxlua', 'docker-hub-creds'){
            def nginxLua = docker.build('qatsi/nginxlua:$BUILD_ID')
            nginxLua.push()
        }
    }
    stage ('Deploy to EC2 with docker-machine') {
        sh '/usr/local/bin/docker-machine create --driver amazonec2 --amazonec2-instance-type "t2.micro" --amazonec2-open-port 80 --amazonec2-open-port 443 --amazonec2-open-port 8080 --amazonec2-access-key [key] --amazonec2-secret-key [key] --amazonec2-ssh-keypath "/var/lib/jenkins/secrets/opskey.pem" --amazonec2-session-token [token] --amazonec2-region us-east-1 --amazonec2-keypair-name opskey --amazonec2-ami "ami-43a15f3e" --amazonec2-ssh-user ubuntu --amazonec2-zone "a" --amazonec2-vpc-id "vpc-e5f4639c" --amazonec2-security-group "default" opstest-$BUILD_ID'
        sh 'eval $(/usr/local/bin/docker-machine env opstest-$BUILD_ID)'
        sh 'docker run -d -p 80:80 --name nginxlua qatsi/nginxlua:$BUILD_ID' // will run on the EC2 node
        sh 'docker exec -ti nginxlua sh -c "/usr/sbin/nginx"'
    }
}

