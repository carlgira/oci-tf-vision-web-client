#!/bin/bash

### Send stdout and stderr to /var/log/cloud-init2.log
exec 1> /var/log/cloud-init2.log 2>&1

echo "========== Install and configure Apache Web server with PHP support"
yum -y install httpd php git

case `hostname` in
"websrv1")  color="linen";;
"websrv2")  color="lightgrey";;
esac

cat >/var/www/html/index.php << EOF
<!DOCTYPE html>
<html>
<head>
<title>OCI vision web client</title>
<style>
body {
  background-color: ${color};
}
#text1 {
  font-size:25px;
  color:black;
}
#text2 {
  font-size:40px;
  color:red;
}
#text3 {
  font-size:25px;
}
td {
  background-color:#D0D0FF;
  text-align: center;
  border: 2px solid blue;
  padding:30px
}
table {
  margin-left:auto;
  margin-right:auto;
  border-spacing: 50px;
}

</style>
</head>
<body>
<table>
<tr>
<td>
<div id="text1"> This web page is served by server </div>
<p>
<div id="text2"> <?php echo gethostname(); ?> </div>
</td>
</tr>
</table>

<div id="text3">
OCI vision web client
<br>
<a href="https://github.com/carlgira/oci-tf-vision-web-client">https://github.com/carlgira/oci-tf-vision-web-client</a>
</div>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd

echo "========== Clone app"
git clone https://github.com/carlgira/oci-vision-web-client /var/www/html/oci-vision-web-client


ENDPOINT=$1
SERVICE_PATH=$2
MODEL_ID=$3
LABELS=$4

echo "Variables $ENDPOINT $SERVICE_PATH $MODEL_ID $LABELS"

echo "========== Replace variables"
sed -i "s/##endpoint##/$ENDPOINT/g" /var/www/html/oci-vision-web-client/js/variables.json
sed -i "s/##path##/$SERVICE_PATH/g" /var/www/html/oci-vision-web-client/js/variables.json
sed -i "s/##modelId##/$MODEL_ID/g" /var/www/html/oci-vision-web-client/js/variables.json
sed -i "s/##labels##/$LABELS/g" /var/www/html/oci-vision-web-client/js/variables.json


echo "========== Open port 80/tcp in Linux Firewall"
/bin/firewall-offline-cmd --add-port=80/tcp


echo "========== Final reboot"
shutdown -r +1