function handler($context, $inputs) {
  ##### Varriables #####
  $ip = $inputs.customProperties.ipProperty   #"10.10.10.10"
  $computeMac = $inputs.macAddresses[0] #"ff:ff:ff:ff:ff:11"
  $IPAMFQDN = $inputs.ipamFqdn
  $secret1 = $context.getSecret($inputs.ipamBase64)
  
  ##### Logging #####
  Write-Host "Updating IP: $ip with MAC: $computeMac in $IPAMFQDN"
  
  ##### Headers #####
  $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
  $headers.Add("Authorization", $secret1)
  $headers.Add("Content-Type", "application/json")
  
  ##### Gets uniq object for IP #####
  $response = Invoke-RestMethod "https://$IPAMFQDN/moreAdrressStuff" -Method 'GET' -Headers $headers -SkipCertificateCheck
  $fixedaddressobject = $response.result.objects
  
  ##### Updates IP MAC address #####
$body = @"
{
  `"mac`": `"$computeMac`",
  `"match_client`": `"MAC_ADDRESS`"
}
"@

  $response = Invoke-RestMethod "https://$IPAMFQDN/wapi/v2.12.3/$fixedaddressobject" -Method 'PUT' -Headers $headers -Body $body -SkipCertificateCheck

}
