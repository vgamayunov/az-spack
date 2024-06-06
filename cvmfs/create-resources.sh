#!/bin/bash

# Create CVMFS server VM with backend on managed disk
az vm create -g hpcbenchswe -n cvmfs-swe \
  --image Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest \
  --data-disk-sizes-gb 1024 \
  --size Standard_D4s_v3 \
  --location swedencentral \
  --vnet-name hpcbenchvnet \
  --admin-username hpcadmin \
  --ssh-key-values "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdn4ojMVbTUjwsqeSdIij/1Sng/6xwEr7yseTuOkHTV7nWcf4X/WfqGUbZr3idB9PzzruUBjT+60nW/Ni22157dwEOpw1+DThd45wwGRs91jDQstI3CyjPNmmzKVuZLMgcekdSu0mgZbCAg5vQNAGPmaSK26DOYjcRLwgUjWIfnNGa3FtAKOZQBjGeFkXt1LHzlstAomlYPfQCFp53XLd/bxEA1qFjKM5TBVO1GqMxbqBplVeDyLkhlrq6/+ItSF9xYhhX86qBQVR+CSPsXniolky/TixVLVczF4++RBvm9B+YGIbzUWUJoaM0q0ph+b3XYk9nXn7WKB6qw0w1Tj8WLkeulLXPNN0gYq5doAwuuqBzOVGpIY3yTWy60nxuUVc1zZeraLhOVn0YwaDh6tJDNaLfKyplXRXt4jyjzZW/bHJrNEcaCc6IfBItRStId6avYx9WuE+HMVmbydiVXvQDzkNYk9xfKe7+FFavNL7Y+wjZ07mryTtsQb5IES968S8= victor@DESKTOP-OCEV05U"
