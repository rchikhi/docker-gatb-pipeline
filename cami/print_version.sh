#echo "1.96"
grep "ENV TAR_GATB_VERSION" Dockerfile | awk '{ print $3 }'
