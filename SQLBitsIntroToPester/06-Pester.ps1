
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$CommandName = $sut.Replace(".ps1", '')
Describe "Tests for the $CommandName Command" {
    It "Command $CommandName exists" {
        Get-Command $CommandName -ErrorAction SilentlyContinue | Should Not BE NullOrEmpty
    }
    Context "$CommandName Input" {
        BeforeAll {
            $MockFace = (Get-Content faces.JSON) -join "`n" | ConvertFrom-Json
            Mock Get-SpeakerFace {$MockFace}
        }
        ## For Checking parameters
        It 'When there is no speaker in the array should return a useful message' {
            Get-SpeakerBeard -Speaker 'Chrissy LeMaire' | Should Be 'No Speaker with a name like that - You entered Chrissy LeMaire'
        }
        It 'Checks the Mock was called for Speaker Face' {
            $assertMockParams = @{
                'CommandName' = 'Get-SpeakerFace'
                'Times'       = 1
                'Exactly'     = $true
            }
            Assert-MockCalled @assertMockParams 
        }

    }
    Context "$CommandName Execution" {
        ## Ensuring the code follows the expected path

    }
    Context "$CommandName Output" {
        ## Probably most of tests here
        BeforeAll {
            $MockFace = (Get-Content faces.JSON) -join "`n" | ConvertFrom-Json
            Mock Get-SpeakerFace {$MockFace}
        }
        It "Should Return the Beard Value for a Speaker" {
            Get-SpeakerBeard -Speaker Jaap | Should Be 0.2
        }
        It "Should Return Speaker Name, Beard Value and URL if Detailed Specified" {
            $Result = (Get-SpeakerBeard -Speaker Jaap -Detailed)
            $Result.Name | Should Be 'JaapBrasser'
            $Result.Beard | Should Be 0.2
            $Result.ImageUrl | Should Be 'http://tugait.pt/2017/wp-content/uploads/2017/04/JaapBrasser-262x272.jpg'
        }
        It 'Checks the Mock was called for Speaker Face' {
            $assertMockParams = @{
                'CommandName' = 'Get-SpeakerFace'
                'Times'       = 2
                'Exactly'     = $true
            }
            Assert-MockCalled @assertMockParams 
        }
    }
    
}