Function Resolve-UrlShortener
{
    Param(
    [Parameter(Mandatory=$true,
                   HelpMessage = 'Input URI to resolve.',
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$URI
    )

    begin
    {
        $CompleteUri = "http://www.getlinkinfo.com/info?link=$URI"
    }

    process
    {
        $RawHTML = Invoke-WebRequest -Uri $CompleteUri
        $ParsedHTML = $RawHTML.ParsedHtml.getElementsByTagName('dd') | Select-Object -ExpandProperty innerText

        $Result = New-Object -TypeName psobject -Property @{
            'Title'        = $ParsedHTML[0]
            'Description'  = $ParsedHTML[1]
            'URL'          = $ParsedHTML[2] -replace '  more info Safe',''
            'ResolvedURL'  = $ParsedHTML[3] -replace '  more info Safe',''
            'HealthStatus' = $ParsedHTML[-1]
            }
    }

    end
    {
        $Result
    }
}
