opt="$1"
case $opt in
        kiali)
                kubectl -n istio-system port-forward svc/kiali 8080:20001
                ;;
        snc)
                alias 2='while [ ! -f /home/crcuser/snc/install.out ]
do
  sleep 2
done
                sudo tail -f /home/crcuser/snc/install.out'
                alias 3='su - crcuser'
                ;;
        mnc)
                alias 2='while [ ! -f /root/ansible.install.out ]
do
  sleep 2
done
                sudo tail -f /root/ansible.install.out'
                alias 21='while [ ! -f /root/ocp/install/.openshift_install.log ]
do
  sleep 2
done
                sudo tail -f /root/ocp/install/.openshift_install.log'
                alias 3='su -';
                ;;
        *)
                alias 2='echo please review /etc/profile.d/env.sh'
                ;;
esac