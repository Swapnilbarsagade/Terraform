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
    default = "sg-0ee8e99c42ea4a2a3"
     
}

variable "this_list" {
    type = list 
    default = ["t2.micro" , "2" , "false"]
     
}
#map and any 