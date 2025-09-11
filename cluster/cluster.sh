#!/bin/bash

# --- Set your subnets ---
SUBNETS="<your_subnet_a>,<your_subnet_b>"

# --- Create EKS cluster using existing VPC ---
eksctl create cluster --name <your_cluster_name>\
                      --region <your_region_name> \
                      --version 1.30 \
                      --without-nodegroup \
                      --vpc-private-subnets $SUBNETS \
