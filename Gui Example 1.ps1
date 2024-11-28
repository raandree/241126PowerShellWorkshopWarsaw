[xml]$xaml = @'
<Window x:Class="WpfApp2.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="576">
    <Grid>
        <ListBox x:Name="lstBox" Margin="10,10,259,10"/>
        <Button x:Name="btnGo" Content="Go" HorizontalAlignment="Left" Margin="371,10,0,0" VerticalAlignment="Top" Height="73" Width="137"/>
        <Button x:Name="btnClear" Content="Clear" HorizontalAlignment="Left" Margin="371,88,0,0" VerticalAlignment="Top" Width="137"/>
        <Button x:Name="btnAddMany" Content="Add many items" HorizontalAlignment="Left" Margin="371,113,0,0" VerticalAlignment="Top" Width="137"/>
        <TextBox x:Name="txtIterations" HorizontalAlignment="Left" Margin="513,113,0,0" TextWrapping="Wrap" Text="50" VerticalAlignment="Top" Width="53"/>

    </Grid>
</Window>
'@

Add-Type -AssemblyName PresentationFramework

$xaml.Window.RemoveAttribute('x:Class')
$xaml.Window.RemoveAttribute('xmlns:local')
$xaml.Window.RemoveAttribute('xmlns:d')
$xaml.Window.RemoveAttribute('xmlns:mc')
$xaml.Window.RemoveAttribute('mc:Ignorable')

#The namespace manager is used to search for the x:Name attributes
#as each UI element has a name defined in the x namespace ('x:Name')
$namespaceManager = New-Object System.Xml.XmlNamespaceManager($xaml.NameTable)
$namespaceManager.AddNamespace('x', 'http://schemas.microsoft.com/winfx/2006/xaml')

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#Find all elements with an x:Name attribute
$uiElements = @{}
$xaml.SelectNodes('//*[@x:Name]', $namespaceManager) | ForEach-Object {
    #and add them to a hashtable with the name as the key
    $uiElements[$_.Name] = $window.FindName($_.Name)
}

#Now we can use the variables to interact with the UI elements and add event handlers
$uiElements.btnGo.Add_Click({
        $uiElements.lstBox.Items.Add((Get-Date))
    })

$uiElements.btnClear.Add_Click({
        $uiElements.lstBox.Items.Clear()
    })

$uiElements.btnAddMany.Add_Click({
        $iterations = [int]$uiElements.txtIterations.Text
        1..$iterations | ForEach-Object {
            Start-Sleep -Milliseconds 100
            $uiElements.lstBox.Items.Add((Get-Date))
        }
    })

$window.ShowDialog()
