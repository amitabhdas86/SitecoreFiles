Import-Module SitecoreFundamentals

Import-Module SitecoreInstallFramework

#define parameters 
$prefix = "sxp9u2" 
$PSScriptRoot = "C:\Sitecore9XP\"
$XConnectCollectionService = "$prefix.xconnect" 
$sitecoreSiteName = "$prefix.sc" 
$SolrUrl = "https://localhost:8983/solr" 
$SolrRoot = "C:\solr\solr-6.6.2\" 
$SolrService = "SolrXP" 
$SqlServer = "WIN-20IDVDM11DL\SQLEXPRESS" 
$SqlAdminUser = "sxpdb" 
$SqlAdminPassword= "Test12345" 

#$solrParams = @{     
#    Path = "$PSScriptRoot\sitecore-solr.json"     
#    SolrUrl = $SolrUrl     
#    SolrRoot = $SolrRoot     
#    SolrService = $SolrService     
#    CorePrefix = $prefix 
#} 

#Install-SitecoreConfiguration @solrParams 
 
#install client certificate for xconnect 
$certParams = @{     
    Path = "$PSScriptRoot\xconnect-createcert.json"     
    CertificateName = "$prefix.xconnect_client" 
    } 
    
Install-SitecoreConfiguration @certParams -Verbose 
 
#install solr cores for xdb 
$solrParams = 
@{     
    Path = "$PSScriptRoot\xconnect-solr.json"     
    SolrUrl = $SolrUrl     
    SolrRoot = $SolrRoot     
    SolrService = $SolrService     
    CorePrefix = $prefix 
} 
Install-SitecoreConfiguration @solrParams -Verbose 
 
#deploy xconnect instance 
$xconnectParams = @{     
    Path = "$PSScriptRoot\xconnect-xp0.json"     
    Package = "$PSScriptRoot\Sitecore 9.0.2 rev. 180604 (OnPrem)_xp0xconnect.scwdp.zip"     
    LicenseFile = "$PSScriptRoot\license.xml"     
    Sitename = $XConnectCollectionService     
    XConnectCert = $certParams.CertificateName     
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix     
    SolrURL = $SolrUrl      
    } 

Install-SitecoreConfiguration @xconnectParams -Verbose 
 
#install solr cores for sitecore $solrParams = 
$solrParams = @{     
    Path = "$PSScriptRoot\sitecore-solr.json"     
    SolrUrl = $SolrUrl     
    SolrRoot = $SolrRoot     
    SolrService = $SolrService     
    CorePrefix = $prefix 
} 

Install-SitecoreConfiguration @solrParams 
 
#install sitecore instance 
$xconnectHostName = "$prefix.xconnect" 
$sitecoreParams = 
@{     
    Path = "$PSScriptRoot\sitecore-XP0.json"     
    Package = "$PSScriptRoot\Sitecore 9.0.2 rev. 180604 (OnPrem)_single.scwdp.zip"  
    LicenseFile = "$PSScriptRoot\license.xml"     
    SqlDbPrefix = $prefix  
    SqlServer = $SqlServer  
    SqlAdminUser = $SqlAdminUser     
    SqlAdminPassword = $SqlAdminPassword     
    SolrCorePrefix = $prefix  
    SolrUrl = $SolrUrl     
    XConnectCert = $certParams.CertificateName     
    Sitename = $sitecoreSiteName    
    XConnectCollectionService = "https://$XConnectCollectionService"    
} 
Install-SitecoreConfiguration @sitecoreParams 