# Define an array to store employee information
$employees = @()

# Add employees to the array
$employees += @{
    ID = 'E001'
    FirstName = 'Alice Johnson'
    Department = 'HR'
    Email = 'alice.johnson@example.com'
    Phone = '(555) 123-4567'
}

$employees += @{
    ID = 'E002'
    Name = 'Bob Smith'
    Department = 'IT'
    Email = 'bob.smith@example.com'
    Phone = '(555) 987-6543'
}

$employees += @{
    ID = 'E003'
    Name = 'Charlie Brown'
    Department = 'Finance'
    Email = 'charlie.brown@example.com'
    Phone = '(555) 555-5555'
}

# Access and display information for a specific employee
$employeeID = 'E002'
$employee = $employees | Where-Object { $_.ID -eq $employeeID }
if ($employee) {
    Write-Host "Employee ID: $($employee.ID)"
    Write-Host "Name: $($employee.Name)"
    Write-Host "Department: $($employee.Department)"
    Write-Host "Email: $($employee.Email)"
    Write-Host "Phone: $($employee.Phone)"
} else {
    Write-Host "Employee ID $employeeID not found."
}

# List all employees
Write-Host "All Employees:"
foreach ($employee in $employees) {
    Write-Host "$($employee.ID): $($employee.Name) - $($employee.Department)"
}
