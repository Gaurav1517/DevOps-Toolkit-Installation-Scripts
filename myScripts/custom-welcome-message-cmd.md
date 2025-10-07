# Add Custom Message with Leading Space to CMD Startup

This guide will show you how to display a custom welcome message with a leading space every time you open Command Prompt (CMD) in Windows.

## Prerequisites

- You need administrative privileges to modify the system registry.

## Steps

Follow the steps below to add a custom message that appears every time you open CMD.

### Step 1: Open Registry Editor

1. Press `Win + R` to open the "Run" dialog box.
2. Type `regedit` and press `Enter` or click "OK" to open the **Registry Editor**.

### Step 2: Navigate to Command Processor Registry Key

1. In the Registry Editor, use the left pane to navigate to the following location:
```

Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor

```

### Step 3: Check if AutoRun String Exists

1. Look for a value named `AutoRun` in the right pane.
2. If `AutoRun` exists, proceed to **Step 4**.
3. If `AutoRun` does not exist, create it:
- Right-click anywhere in the right pane → `New` → `String Value`.
- Name the new string `AutoRun`.

### Step 4: Modify the `AutoRun` Value

1. Right-click on the `AutoRun` value and select **Modify**.
2. In the **Value data** box, enter the following:
```

echo. Welcome to this computer, %USERNAME%!

```
- **Explanation:** The `echo.` command adds a blank line before your custom message, making it appear with a leading space.

### Step 5: Save and Exit

1. Click **OK** to save the changes.
2. Close the **Registry Editor**.

### Step 6: Test the Custom Message

1. Open a new **Command Prompt** (`cmd.exe`).
2. You should now see a blank line followed by your custom welcome message, such as:
```

Welcome to this computer, UserName!

````

## Troubleshooting

- If you don’t see the message, make sure you've correctly followed all the steps.
- Ensure the `AutoRun` value is pointing to the correct command (`echo. Welcome to this computer, %USERNAME%!`).

## Notes

- `%USERNAME%` is a variable that dynamically pulls the username of the person currently logged into the computer.
- This modification only affects the Command Prompt. Other terminal applications (like PowerShell) will not show this message.

---

### Additional Customizations

You can customize the message to include other variables or change the text. Here are a few examples:
- To include the system time: 
```bash
echo. Welcome, %USERNAME%! The time is %TIME%.
````
OR
```bash
echo. 🎉 Welcome to your computer, ❤️ Gaurav!
```

* To display system information:

  ```bash
  echo. Welcome, %USERNAME%! Your computer's hostname is %COMPUTERNAME%.
  ```

That's it! You've successfully added a custom welcome message to CMD with a leading space.

---
