#Create an empty hashtable to store employee information
$employees = @{}

# Add employees to the hashtable
$employees['E001'] = @{
    Name = 'Alice Johnson'
    Department = @{
        ID = 1
        Name = 'HR'
    }
    Email = 'alice.johnson@example.com'
    Phone = '(555) 123-4567'
}

$employees['E002'] = @{
    Name = 'Bob Smith'
    Department = 'IT'
    Email = 'bob.smith@example.com'
    Phone = '(555) 987-6543'
}

$employees['E003'] = @{
    Name = 'Charlie Brown'
    Department = 'Finance'
    Email = 'charlie.brown@example.com'
    Phone = '(555) 555-5555'
}

# Access and display information for a specific employee
$employeeID = 'E002'
if ($employees.ContainsKey($employeeID)) {
    $employee = $employees[$employeeID]
    Write-Host "Employee ID: $employeeID"
    Write-Host "Name: $($employee.Name)"
    Write-Host "Department: $($employee.Department)"
    Write-Host "Email: $($employee.Email)"
    Write-Host "Phone: $($employee.Phone)"
} else {
    Write-Host "Employee ID $employeeID not found."
}

# List all employees
Write-Host "All Employees:"
foreach ($key in $employees.Keys) {
    $employee = $employees[$key]
    Write-Host "$key: $($employee.Name) - $($employee.Department)"
}
