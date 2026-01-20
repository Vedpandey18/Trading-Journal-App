# Git Commands for CMD/PowerShell

## 📤 Push Project to GitHub

### Step 1: Check Current Status
```cmd
git status
```

### Step 2: Add All Changes
```cmd
git add .
```

### Step 3: Commit Changes
```cmd
git commit -m "Remove personal information and update admin credentials"
```

### Step 4: Create GitHub Repository First
1. Go to https://github.com
2. Click **"+"** → **"New repository"**
3. Name: `trading-journal`
4. Choose **Private** or **Public**
5. **DO NOT** initialize with README
6. Click **"Create repository"**

### Step 5: Add Remote Repository

**Replace `YOUR_USERNAME` with your GitHub username:**

```cmd
git remote add origin https://github.com/YOUR_USERNAME/trading-journal.git
```

**Or if you prefer SSH:**
```cmd
git remote set-url origin git@github.com:YOUR_USERNAME/trading-journal.git
```

### Step 6: Rename Branch to Main (if needed)
```cmd
git branch -M main
```

### Step 7: Push to GitHub
```cmd
git push -u origin main
```

**If prompted for credentials:**
- **Username:** Your GitHub username
- **Password:** Use a **Personal Access Token** (not your GitHub password)
  - Generate token: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
  - Select scope: `repo` (full control)

---

## 🔄 Future Updates

After initial push, use these commands to update GitHub:

```cmd
git add .
git commit -m "Your commit message here"
git push
```

---

## 📋 Complete Command Sequence (Copy-Paste)

```cmd
REM Check status
git status

REM Add all changes
git add .

REM Commit changes
git commit -m "Remove personal information and update admin credentials"

REM Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/trading-journal.git

REM Rename branch
git branch -M main

REM Push to GitHub
git push -u origin main
```

---

## 🔍 Useful Git Commands

### Check Remote URL
```cmd
git remote -v
```

### Change Remote URL
```cmd
git remote set-url origin https://github.com/YOUR_USERNAME/trading-journal.git
```

### View Commit History
```cmd
git log --oneline
```

### View Current Branch
```cmd
git branch
```

### Pull Latest Changes
```cmd
git pull origin main
```

### Clone Repository (if needed)
```cmd
git clone https://github.com/YOUR_USERNAME/trading-journal.git
```

---

## ⚠️ Troubleshooting

### If remote already exists:
```cmd
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/trading-journal.git
```

### If push fails due to authentication:
1. Generate Personal Access Token on GitHub
2. Use token as password when prompted
3. Or configure Git Credential Manager:
   ```cmd
   git config --global credential.helper manager-core
   ```

### If branch name mismatch:
```cmd
git branch -M main
git push -u origin main
```

---

## ✅ Success Indicators

After successful push, you should see:
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
Writing objects: 100% (X/X), done.
To https://github.com/YOUR_USERNAME/trading-journal.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

Your project is now on GitHub! 🎉
