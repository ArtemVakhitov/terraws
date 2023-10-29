# Terraws

This Terraform template creates the required number of AWS instances of type t2.xxx with the required amount of RAM (in GiB) and vCPU. If too little RAM is requested for this number of CPUs, it instead creates a t2 instance with more RAM to match the CPU number, and vice versa. Any amount of RAM less than 1 GiB is interpreted as 0.5 GiB (t2.nano).