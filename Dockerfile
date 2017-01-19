#
# Image configured with systemd, docker-in-docker and kubeadm.  Useful
# for simulating multinode Kubernetes deployments.
#
# The standard name for this image is maru/kubeadm
#
# Notes:
#
#  - disable SELinux on the docker host (not compatible with dind)
#
#  - to use the overlay graphdriver, ensure the overlay module is
#    installed on the docker host
#
#      $ modprobe overlay
#
#  - run with --privileged
#
#      $ docker run -d --privileged maru/kubeadm
#

FROM maru/systemd-dind

ADD k8s.repo /etc/yum.repos.d/

RUN dnf -y update && dnf -y install\
 kubeadm\
 kubelet\
 kubectl\
 kubernetes-cni\
 bind-utils\
 bridge-utils\
 ebtables\
 findutils\
 hostname\
 htop\
 iproute\
 iputils\
 less\
 net-tools\
 procps-ng\
 tcpdump\
 traceroute\
 which\
 && dnf clean all

RUN systemctl enable kubelet

# kubeadm requires /etc/kubernetes to be empty
RUN rmdir /etc/kubernetes/manifests

# Docker requires /run have shared propagation in order to start the
# kube-proxy container.
RUN echo 'mount --make-shared /run' >> /usr/local/bin/dind-setup.sh
