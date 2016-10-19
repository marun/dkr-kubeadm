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
 ebtables\
 findutils\
 hostname\
 htop\
 iproute\
 iputils\
 procps-ng\
 which\
 && dnf clean all

RUN systemctl enable kubelet

# kubeadm requires /etc/kubernetes to be empty
RUN rmdir /etc/kubernetes/manifests
