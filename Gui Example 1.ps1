[xml]$xaml = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp2"

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

#The namespace manager is used to search for the x:Name attributes
#as each UI element has a name defined in the x namespace ('x:Name')
$namespaceManager = New-Object System.Xml.XmlNamespaceManager($xaml.NameTable)
$namespaceManager.AddNamespace('x', 'http://schemas.microsoft.com/winfx/2006/xaml')

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

#Find all elements with an x:Name attribute
$xaml.SelectNodes('//*[@x:Name]', $namespaceManager) | ForEach-Object {
    try {
        #and create a variable for each of them
        Set-Variable -Name "ui_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
    }
    catch {
        throw
    }
}

#Now we can use the variables to interact with the UI elements and add event handlers
$ui_btnGo.Add_Click({
        $ui_lstBox.Items.Add((Get-Date))
    })

$ui_btnClear.Add_Click({
        $ui_lstBox.Items.Clear()
    })

$ui_btnAddMany.Add_Click({
        $iterations = [int]$ui_txtIterations.Text
        1..$iterations | ForEach-Object {
            Start-Sleep -Milliseconds 100
            $ui_lstBox.Items.Add((Get-Date))
        }
    })

$window.ShowDialog()
