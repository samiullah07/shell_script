import boto3

s3=boto3.resource("s3")

def get_s3_bucket(s3):
    for bucket in s3.buckets.all():
        print(bucket)


def create_bucket(s3):
    s3.create_bucket(Bucket="devops-bucket-008", CreateBucketConfiguration={
            "LocationConstraint": 'us-east-2',


        },)

    print("Bucket created successfully")



def upload_file_bucket(s3,file_name,key_name,bucket_name):
    data = open(file_name,'rb')
    s3.Bucket(bucket_name).put_object(Key=key_name, Body=data)
    print("Bucket upload")
    

file_name = "/home/samiullah/python_backup/backup_2026-01-03.tar.gz"
key_name = "Devops-bucket"
bucket_name = "devops-bucket-008"
upload_file_bucket(s3,file_name,key_name,bucket_name)
get_s3_bucket(s3)
    
