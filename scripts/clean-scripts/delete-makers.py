#!python3
import boto3
import botocore

BUCKET_NAME = 'new-bucket'
s3 = boto3.resource('s3')


def main():
    bucket = s3.Bucket(BUCKET_NAME)
    versions = bucket.object_versions

    for version in versions.all():
        if is_delete_marker(version):
             version.delete()


def is_delete_marker(version):
    try:
        # note head() is faster than get()
        version.head()
        return False
    except botocore.exceptions.ClientError as e:
        if 'x-amz-delete-marker' in e.response['ResponseMetadata']['HTTPHeaders']:
            return True
        # an older version of the key but not a DeleteMarker
        elif '404' == e.response['Error']['Code']:
            return False


if __name__ == '__main__':
    main()

