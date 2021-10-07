install_splunk() {
    echo " ************************"
    echo " **** Install Splunk ****"
    echo " ************************"
    cd /opt
    sudo mkdir splunk 
    cd /opt/splunk
    sudo wget -O splunk-8.2.2.1-ae6821b7c64b-linux-2.6-amd64.deb 'https://d7wz6hmoaavd0.cloudfront.net/products/splunk/releases/8.2.2.1/linux/splunk-8.2.2.1-ae6821b7c64b-linux-2.6-amd64.deb'
    sudo dpkg -i /opt/splunk/splunk-8.2.2.1-ae6821b7c64b-linux-2.6-amd64.deb
##    sudo wget -O splunk-8.1.3-63079c59e632-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=8.1.3&product=splunk&filename=splunk-8.1.3-63079c59e632-linux-2.6-amd64.deb&wget=true'
##    sudo dpkg -i /opt/splunk/splunk-8.1.3-63079c59e632-linux-2.6-amd64.deb
    sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd ${splunk_password}
}

set_profile() {
    echo " ************************"
    echo " **** Set .profile  ****"
    echo " ************************"
    sudo touch ~/.profile
    sudo echo export SPLUNK_HOME=/opt/splunk >> ~/.profile
    sudo echo export SPLUNK_DB=/opt/splunk/var/lib/splunk/defaultdb >> ~/.profile
    cat ~/.profile
    sudo cp /tmp/indexes.conf /opt/splunk/etc/system/local
}

install_event_gen() {
    echo " ************************"
    echo " ****    EventGen    ****"
    echo " ************************"
    sudo cp -r /tmp/splunk-eventgen-guide/tutorial/ /opt/splunk/etc/apps/
    sudo tar -xvf /tmp/splunk-eventgen-guide/eventgen_721.tgz -C /opt/splunk/etc/apps/
    sudo sed -i 's/disabled = true/disabled = false/g' /opt/splunk/etc/apps/SA-Eventgen/default/inputs.conf
    sudo /opt/splunk/bin/splunk stop
    sudo systemctl stop Splunkd
    sudo cd /tmp/
    sudo chown -Rh splunk:splunk /opt/splunk/
    sudo /opt/splunk/bin/splunk enable boot-start -user splunk
}

install_apps() {
    echo " ********************************"
    echo " **** Install SplunkBaseApps ****"
    echo " ********************************"
    git clone https://github.com/anthonygrees/lw_splunk_eventgen_7x /tmp/splunk-eventgen-guide
    sudo /opt/splunk/bin/splunk install app /tmp/splunk-eventgen-guide/apps/lacework-add-on-for-splunk_115.tgz -auth admin:${splunk_password}
    sudo /opt/splunk/bin/splunk install app /tmp/splunk-eventgen-guide/apps/lacework-app_114.tgz -auth admin:${splunk_password}
    sudo /opt/splunk/bin/splunk install app /tmp/splunk-eventgen-guide/apps/lacework-events-add-on_111.tgz -auth admin:${splunk_password}
}

install_splunk
set_profile
install_apps
install_event_gen