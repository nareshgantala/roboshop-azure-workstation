sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/rpm-stable/jenkins.repo
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install fontconfig java-21-openjdk
sudo yum install jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

sudo systemctl start jenkins

# Wait for Jenkins to actually generate the password file
echo "Waiting for Jenkins to initialize..."
while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]
do
  sleep 5
done

echo "Jenkins is ready. Your Initial Admin Password is:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword