

		$ModuleName = 'AzureRM.RedisCache'
		$ModuleVersion = '2.1.0'
		$ManifestPath  = 'C:\Users\matt.quickenden\Documents\GitHub\Manifests'


	Import-Module $ModuleName
	$Module = Get-Module $ModuleName | ? {$_.version -eq $ModuleVersion}
	$Mpath = Get-Item $Module.Path
	$FunctionList = @(get-command -module $ModuleName)
	$AllFunctions = Get-Functions -path $Mpath.PSParentPath
	$PSGallery = Find-Module $ModuleName 

	$rpt = @()
	$rpt += Get-HTMLOpenPage -TitleText ("Powershell Module Manifest - " + $ModuleName + " (" + $Module.Version + ")") -leftLogoName Corporate -RightLogoName PowerShell
	$rpt += Get-HTMLTabHeader -TabNames 'Summary','Cmdlet Descriptions','Cmdlets with Parameters','Module Manifest','Cmdlet Listing','About'

	$rpt += Get-Content "$ManifestPath\contents.part"

	$rpt += get-htmltabcontentopen -TabName "Cmdlet Listing" -tabheading ' '
	$rpt += Get-HTMLContentOpen -HeaderText "Complete PowerShell Cmdlet Listing" 
	$ArrayOfObjects = Get-Command | select  Name	,CommandType	,Source	,Version	,Visibility	,ModuleName	,Module 
	$rpt += Get-HTMLContentDataTable $ArrayOfObjects
	$rpt += Get-HTMLContentClose
	$rpt += get-htmltabcontentclose

	#region Details 
	$rpt += get-htmltabcontentopen -TabName "Summary" -tabheading ' '
		$rpt += Get-HTMLContentOpen -HeaderText "$ModuleName Details" -BackgroundShade 2
			
            $rpt += Get-HTMLContentOpen -HeaderText "Module Details" 
                $rpt += Get-HTMLContentText  -Heading "Author" -Detail $Module.Author
			    $rpt += Get-HTMLContentText  -Heading "CompanyName" -detail $Module.CompanyName
			    $rpt += Get-HTMLContentText  -Heading "Description" -detail $Module.Description	
			    $rpt += Get-HTMLContentText  -Heading "Path" -Detail $Module.Path
			$rpt += Get-HTMLContentClose
		
			$InstalledPSG = Get-InstalledModule $ModuleName
			$PSG = Find-Module $ModuleName
			$rpt += Get-HTMLContentOpen -HeaderText 'PS Gallery'
				$rpt += Get-HTMLContentText  -Heading "Description" -Detail $InstalledPSG.Description
				$rpt += Get-HTMLContentText  -Heading "PublishedDate" -detail $InstalledPSG.PublishedDate
				$rpt += Get-HTMLContentText  -Heading "Install Date" -detail $InstalledPSG.InstalledDate
				$rpt += Get-HTMLContentText  -Heading "Install Location" -detail $InstalledPSG.InstalledLocation
				$rpt += Get-HTMLContentText  -Heading "Installed Version" -detail $InstalledPSG.Version
				$rpt += Get-HTMLContentText  -Heading "Avaliable Version" -detail $PSGallery.Version.ToString()
				$rpt += Get-HTMLContentText  -Heading "ProjectUri" -detail ("URL01$InstalledPSG.ProjectUriURL02Project LinkURL03")
				$Dependancies = ''
				($PSG.Dependencies | %{ $Dependancies += $_.Name + ", "} )
				$rpt += Get-HTMLContentText  -Heading "Dependencies" -detail $Dependancies
				
			$rpt += Get-HTMLContentClose
			
			$rpt += Get-HtmlContentOpen -HeaderText "Cmdlets List" 
				$rpt += Get-HTMLContentTable  ($AllFunctions | select FunctionName)
			$rpt += Get-HtmlContentclose

			$rpt += Get-HtmlContentOpen -HeaderText "Functions in Code"  -IsHidden
				$rpt += Get-HTMLContentTable  (($AllFunctions | sort FileName,Line) | select FileName, FunctionName, Line	) -GroupBy FileName	
			$rpt += Get-HtmlContentclose
			
		$rpt += Get-HTMLContentClose
	$rpt += get-htmltabcontentclose
	#Endregion

	#region FunctionList
		$rpt += get-htmltabcontentopen -TabName 'Cmdlet Descriptions' -tabheading ' '
	        $rpt += Get-HtmlContentOpen -HeaderText "Functions with Parameters" -BackgroundShade 2
	        foreach ($function in ( $FunctionList  | sort Name))
			{
	                $rpt += Get-HtmlContentOpen  -HeaderText ($function.Name)
	                $FunctionHelp = Get-Help $function.Name
	                    $rpt += Get-HTMLContentText -Heading "Name" -Detail ($FunctionHelp.Name)
	                    $rpt += Get-HTMLContentText -Heading "Synopsis" -Detail ($FunctionHelp.synopsis)
	                    #$rpt += Get-HTMLContentText -Heading "syntax" -Detail ($FunctionHelp.syntax)
						$rpt += Get-HTMLContentText -Heading "Remarks" -Detail ($FunctionHelp.Remarks)
	                    foreach ($Example in @($FunctionHelp.Examples)) {
							$exText = ($Example.example)
							$rpt += Get-HTMLContentText -Heading "introduction" -Detail $exText.title
							$rpt += Get-HTMLContentText -Heading "introduction" -Detail $exText.introduction
							$rpt += Get-HTMLContentText -Heading "introduction" -Detail $exText.commandLines
							$rpt += Get-HTMLContentText -Heading "introduction" -Detail $exText.remarks
							
							$rpt += Get-HTMLContentText -Heading "Examples" -Detail (Get-HTMLCodeBlock -Code $exText.code -Style PowerShell) 
						}
	                $rpt += Get-HtmlContentclose
	        }
	    	$rpt += Get-Htmlcontentclose
	    $rpt += get-htmltabcontentclose
	#endregion

	#region Params
	$rpt += get-htmltabcontentopen -TabName 'Cmdlets with Parameters' -tabheading ' '
	$rpt += Get-HTMLAnchor -AnchorName "Top"
	    $rpt += Get-HtmlContentOpen -HeaderText "Available Functions "  
	          $rpt += ($FunctionList | % { (Get-HTMLAnchorLink -AnchorName $_.Name -AnchorText $_.Name ) + '<BR>'} )
	    $rpt += Get-HtmlContentclose
	          $rpt += Get-HtmlContentOpen -HeaderText "Functions with Parameters" -BackgroundShade 2
	          foreach ($function in ( $FunctionList | sort Name)){
	                $rpt += Get-HTMLAnchorlink -AnchorName Top -AnchorText 'Back To  List'
	                $Params = @(Get-Parameters -Cmdlet $function.Name)
	                
	                if ($Params.count -gt 0) {
	                      $rpt += Get-HtmlContentOpen  -HeaderText ($function.Name) -Anchor $function.Name
	                      $FunctionHelp = Get-Help $function.Name
	                      $rpt += Get-HtmlContentOpen  -HeaderText Overview 
						  	$rpt += Get-HTMLContentText -Heading "Name" -Detail ($FunctionHelp.Name)
	                      	$rpt += Get-HTMLContentText -Heading "Synopsis" -Detail ($FunctionHelp.synopsis)
	                      	$rpt += Get-HTMLContentText -Heading "Remarks" -Detail ($FunctionHelp.Remarks)
	                      	$rpt += Get-HTMLContentText -Heading "Examples" -Detail ($FunctionHelp.Examples)
						  $rpt += Get-HtmlContentclose
	                            $rpt += Get-HtmlContentOpen -HeaderText 'Functions Parameters' 
	                                  $rpt += Get-HtmlContentTable (Set-TableRowColor ($Params | select ParameterSet, Name ,Type ,IsMandatory  ,Pipeline ) -Alternating ) -GroupBy ParameterSet -Fixed 
	                            $rpt += Get-HtmlContentclose
	                      $rpt += Get-HtmlContentclose
	                }
	          }
	        $rpt += Get-Htmlcontentclose
	    $rpt += get-htmltabcontentclose
	#endregion

	$rpt += Get-HTMLClosePage 
	Write-Output $ManifestPath
	$Helpfile = Save-HTMLReport -ReportContent $rpt -ReportPath $ManifestPath -ReportName ($ModuleName + "-" + $Module.Version)
invoke-item $Helpfile 