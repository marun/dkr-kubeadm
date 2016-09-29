#
# Image configured with systemd, docker-in-docker and kubeadm.  Useful
# for simulating multinode Kubernetes deployments.
#
# The standard name for this image is maru/systemd-kubeadm
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
#      $ docker run -d --privileged maru/systemd-kubeadm
#

FROM maru/systemd-dind

ADD k8s.repo /etc/yum.repos.d/

RUN yum -y update && yum -y install\
 kubeadm\
 kubelet\
 kubectl\
 kubernetes-cni\
 && yum clean all

RUN systemctl enable kubelet
