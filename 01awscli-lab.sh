# v1.0
###############################################################################
AWS_VPC_CIDR_BLOCK=10.2.0.0/16
AWS_Subred_CIDR_BLOCK=10.2.100.0/24
AWS_IP_UbuntuServer=10.2.100.100
AWS_IP_WindowsServer=10.2.100.200
AWS_Proyecto=prueba
#####
echo "######################################################################"
echo "Creando VPC..."

AWS_ID_VPC=$(aws ec2 create-vpc \
  --cidr-block $AWS_VPC_CIDR_BLOCK \
  --tag-specification ResourceType=vpc,Tags=[{Key=Name,Value=$AWS_Proyecto-vpc}] \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text)
## Crear una subred publica con su etiqueta
echo "Creando Subred publica..."
AWS_ID_SubredPublica=$(aws ec2 create-subnet \
  --vpc-id $AWS_ID_VPC --cidr-block $AWS_Subred_CIDR_BLOCK \
  --availability-zone us-east-1a \
  --tag-specifications ResourceType=subnet,Tags=[{Key=Name,Value=$AWS_Proyecto-subred-publica}] \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text)