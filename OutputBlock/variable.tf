variable "this_image_id" {
  type        = string
  default = "ami-042e76978adeb8c48"
}

variable "this_disable_api_stop" {
  type        = bool
  default = false
}
variable "this_disable_api_termination" {
    type = bool 
    default = false
    description = "this variable is used to pass bool data to api_termination" 
}
variable "this_count" {
    type = number 
    default = 2
     
}
variable "this_vpc_security_group_ids" {
    type = string 
    default = "sg-0505874879e7ce6cd"
     
}

variable "this_list" {
    type = list 
    default = ["t2.micro" , "2" , "false"]
     
}

variable "this_map" {
    type = map  
    default = {
     purposeec2 = "webserver"   
     termination = true 
     count = 1

    }
     
}

#vpc variables starts from here 
variable "this_vpc_cidr_block" {
    type = string
    default = "12.11.0.0/16"
}
variable "this_vpc_tags" {
     type = string
     default = "this_vpc"
}
variable "this_subnet_pub_cidr_block" {
     type = string
     default = "12.11.0.0/17"
}

variable "this_subnet_pub_map_ip" {
    type = bool
    default = true
}
variable "this_subnet_pub_tags" {
    type = string
    default = "pub_subnet"
}
