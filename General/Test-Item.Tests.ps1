$here = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
    . "$here\$sut"

    Describe "Test-Item" {
    		Context "when directory exists" {
    		
	    		Setup -Dir "DirectoryThatExists"
					$testDir = "TestDrive:\DirectoryThatExists"
					
					$script:testY = ""
					$script:testN = ""
					$script:testA = ""
					
	        Test-Item $testDir `
	        	-Yes { $script:testY = $_  } `
	        	-No { $script:testN = $_ } `
	        	-Always { $script:testA = $_ }

	        It "executes -Yes" {
	            $script:testY | should not benullorempty
	        }
	        It 'passes item as $_ to -Yes' {
	        	$script:testY | should be $testDir
	        }
	  		It "does not execute -No" {
	            $script:testN | should benullorempty
	        }
	        It "executes -Always" {
	            $script:testA | should not benullorempty
	        }
	        It 'passes item as $_ to -Always' {
				$script:testA | should be $testDir
	        }
        }
        
        
        Context "when directory does not exists" {
    		
	    		$testDir = "TestDrive:\DirectoryThatDoesNotExists"

					$script:testY = ""
					$script:testN = ""
					$script:testNValue = ""
					$script:testA = ""
					$script:testAValue = ""
					
	        Test-Item $testDir `
	        	-Yes { $script:testY = $true  } `
	        	-No { 
	        		$script:testN = $true 
	        		$script:testNValue = $_
	        	} `
	        	-Always { 
	        		$script:testA = $true 
	        		$script:testAValue = $_
	        	}

	        It "does not execute -Yes" {
	            $script:testY | should benullorempty
	        }
	  		It "executes -No" {
	            $script:testN | should be $true
	        }
	        It 'passes item as $_ to -No' {
	        	$script:testNValue | should be $testDir
	        }
	        It "executes -Always" {
	            $script:testA | should be $true
	        }
	        It 'passes item as $_ to -Always' {
				$script:testAValue | should be $testDir
	        }
        }
    }
