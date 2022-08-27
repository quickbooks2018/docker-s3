- https://cloudgeeks.ca

- Bucket Policy

```policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::<s3_bucket>"
        },
        {
            "Action": [
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::<s3_bucket>/*"
        }
    ]
}
```




- docker s3 mount 

```s3
docker compose up -d --build
```

- DEBUG -o dbglevel=info -f -o curldbg
- PATH  -o url="https://s3.us-east-1.amazonaws.com"
- cat /etc/fuse.conf