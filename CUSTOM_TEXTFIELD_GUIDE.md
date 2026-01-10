# CustomTextField Widget Guide

A fully customizable text field widget with **4 states** following exact design specifications.

---

## 🎨 **Features**

### ✅ **4 Visual States**
1. **Normal** - Light gray border, no icon
2. **Focused** - Dark border when tapped
3. **Error** - Red border, error icon, error message
4. **Success** - Green border, checkmark icon

### ✅ **Built-in Features**
- Label text above field
- Placeholder text
- Password visibility toggle
- Custom validation
- Error messages
- Success indicators
- Prefix/suffix icons
- Auto-validation on blur
- Character limits
- Custom keyboard types

---

## 📖 **Usage Examples**

### **1. Basic Text Field**
```dart
CustomTextField(
  label: 'Full Name',
  hintText: 'Enter your full name',
  controller: _nameController,
)
```

### **2. Email Field with Validation**
```dart
CustomTextField(
  label: 'Email',
  hintText: 'Enter your email address',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  showSuccessState: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter valid email address';
    }
    return null;
  },
)
```

### **3. Password Field**
```dart
CustomTextField(
  label: 'Password',
  hintText: 'Enter your password',
  controller: _passwordController,
  obscureText: true,
  showSuccessState: true,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  },
)
```

### **4. Field with Error Message**
```dart
CustomTextField(
  label: 'Email',
  hintText: 'Enter your email',
  controller: _emailController,
  errorText: 'Please enter valid email address',
)
```

---

## 🎯 **Parameters**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `String?` | `null` | Label text above field |
| `hintText` | `String?` | `null` | Placeholder text |
| `controller` | `TextEditingController?` | `null` | Text controller |
| `validator` | `String? Function(String?)?` | `null` | Validation function |
| `obscureText` | `bool` | `false` | Hide text (password) |
| `keyboardType` | `TextInputType?` | `null` | Keyboard type |
| `prefixIcon` | `Widget?` | `null` | Icon before text |
| `suffixIcon` | `Widget?` | `null` | Custom suffix icon |
| `maxLines` | `int?` | `1` | Maximum lines |
| `maxLength` | `int?` | `null` | Max character count |
| `enabled` | `bool` | `true` | Enable/disable field |
| `onChanged` | `void Function(String)?` | `null` | Text change callback |
| `onSubmitted` | `void Function(String)?` | `null` | Submit callback |
| `inputFormatters` | `List<TextInputFormatter>?` | `null` | Input formatters |
| `textInputAction` | `TextInputAction?` | `null` | Keyboard action |
| `focusNode` | `FocusNode?` | `null` | Focus node |
| **`showSuccessState`** | **`bool`** | **`false`** | **Show green checkmark** |
| **`errorText`** | **`String?`** | **`null`** | **Force error state** |

---

## 🎨 **States & Design Specs**

### **1. Normal State**
```
┌────────────────────────────┐
│ Full Name                  │  ← Label (16sp, #111827)
├────────────────────────────┤
│ Enter your full name       │  ← Placeholder (16sp, #9CA3AF)
└────────────────────────────┘
  ↑
  Light gray border (#E5E7EB, 1.5px)
  Border radius: 12px
```

### **2. Focused State**
```
┌────────────────────────────┐
│ Email                      │
├════════════════════════════┤  ← Dark border (#111827, 2px)
│ cody.fisher45@example|     │
└────────────────────────────┘
```

### **3. Error State**
```
┌────────────────────────────┐
│ Email                      │
├════════════════════════════┤  ← Red border (#DC2626, 2px)
│ cody.fisher45@example   ⚠️ │  ← Error icon (20px)
└────────────────────────────┘
  ⚠️ Please enter valid email address  ← Error text (13sp, #DC2626)
```

### **4. Success State**
```
┌────────────────────────────┐
│ Email                      │
├════════════════════════════┤  ← Green border (#16A34A, 2px)
│ cody.fisher45@example.com ✓│  ← Checkmark (20px, green)
└────────────────────────────┘
```

---

## 🎭 **State Logic**

### **When to Show Each State**

```dart
Priority (highest to lowest):
1. Error state   → errorText != null OR validator returns error
2. Success state → showSuccessState = true AND text not empty
3. Focused state → Field is focused/tapped
4. Normal state  → Default state
```

### **Automatic Validation**

The field validates automatically:
- ✅ **On focus lost** (blur) - Runs validator
- ✅ **While typing** - Clears error if present
- ✅ **On text change** - Updates success state

---

## 💡 **Advanced Examples**

### **Phone Number Field**
```dart
CustomTextField(
  label: 'Phone Number',
  hintText: '+1 (555) 000-0000',
  controller: _phoneController,
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
  validator: (value) {
    if (value == null || value.length < 10) {
      return 'Please enter valid phone number';
    }
    return null;
  },
  showSuccessState: true,
)
```

### **Multi-line Text Area**
```dart
CustomTextField(
  label: 'Bio',
  hintText: 'Tell us about yourself',
  controller: _bioController,
  maxLines: 4,
  maxLength: 200,
  textInputAction: TextInputAction.newline,
)
```

### **Field with Prefix Icon**
```dart
CustomTextField(
  label: 'Search',
  hintText: 'Search products...',
  controller: _searchController,
  prefixIcon: const Padding(
    padding: EdgeInsets.all(12),
    child: Icon(Icons.search, size: 20),
  ),
)
```

### **Disabled Field**
```dart
CustomTextField(
  label: 'Username',
  hintText: 'john_doe',
  controller: _usernameController,
  enabled: false,
)
```

---

## 🎨 **Color Specifications**

| State | Border Color | Border Width | Text Color | Icon Color |
|-------|-------------|--------------|------------|------------|
| Normal | `#E5E7EB` | 1.5px | `#111827` | - |
| Focused | `#111827` | 2px | `#111827` | - |
| Error | `#DC2626` | 2px | `#111827` | `#DC2626` |
| Success | `#16A34A` | 2px | `#111827` | `#16A34A` |
| Placeholder | - | - | `#9CA3AF` | - |
| Label | - | - | `#111827` | - |
| Error Text | - | - | `#DC2626` | - |

---

## 🔧 **Password Field Behavior**

When `obscureText = true`:
- ✅ Shows eye icon on the right
- ✅ Icon toggles between visible/hidden
- ✅ Eye closed = password hidden
- ✅ Eye open = password visible
- ✅ Error/success icons don't show (only eye icon)

---

## 📝 **Validation Patterns**

### **Email Validation**
```dart
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!EmailValidator.validate(value)) {
    return 'Please enter valid email address';
  }
  return null;
}
```

### **Password Validation**
```dart
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain uppercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain number';
  }
  return null;
}
```

### **Name Validation**
```dart
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  if (value.length < 2) {
    return 'Name must be at least 2 characters';
  }
  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return 'Name can only contain letters';
  }
  return null;
}
```

---

## 🎯 **Form Integration**

### **Complete Form Example**
```dart
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            label: 'Full Name',
            hintText: 'Enter your full name',
            controller: _nameController,
            showSuccessState: true,
            validator: validateName,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Email',
            hintText: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            showSuccessState: true,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          
          CustomTextField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            showSuccessState: true,
            validator: validatePassword,
          ),
          const SizedBox(height: 24),
          
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid
                print('Form submitted!');
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔍 **Testing the States**

### **View Example Page**
Run the example page to see all states:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CustomTextFieldExample(),
  ),
);
```

Or import in your router:
```dart
import 'package:fashion_ecommerce/core/widgets/custom_text_field_example.dart';
```

---

## 🎨 **Customization**

### **Change Colors**
Modify colors in `custom_text_field.dart`:

```dart
// Line 100 - Error color
return const Color(0xFFDC2626); // Change to your error color

// Line 102 - Success color
return const Color(0xFF16A34A); // Change to your success color

// Line 106 - Normal border
return const Color(0xFFE5E7EB); // Change to your border color
```

### **Change Border Radius**
```dart
// Line 217 - Border radius
borderRadius: BorderRadius.circular(12), // Change radius
```

### **Change Icon Sizes**
```dart
// Line 126 - Error/Success icons
size: 20, // Change icon size
```

---

## ✅ **Best Practices**

1. **Always use controllers** for fields you need to validate
2. **Enable `showSuccessState`** for validated fields
3. **Provide clear error messages** (not "Invalid input")
4. **Use proper keyboard types** (email, phone, number)
5. **Validate on blur** (automatic with this widget)
6. **Show immediate feedback** on success
7. **Keep error messages short** and actionable

---

## 📊 **Performance**

- ✅ Efficient state management with `StatefulWidget`
- ✅ Minimal rebuilds (only when needed)
- ✅ Automatic cleanup of focus nodes
- ✅ No memory leaks

---

## 🐛 **Troubleshooting**

### **Success state not showing**
```dart
// Make sure to enable it:
showSuccessState: true,  // ← Add this!
```

### **Validation not working**
```dart
// Make sure controller is provided:
controller: _emailController,  // ← Required for validation
validator: validateEmail,       // ← Validator function
```

### **Error message not showing**
```dart
// Either use validator OR errorText, not both
validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
// OR
errorText: 'This field is required',
```

---

## 🎉 **Summary**

Your `CustomTextField` now has:
- ✅ **4 states** - Normal, Focused, Error, Success
- ✅ **Auto-validation** on blur
- ✅ **Success indicators** with checkmark
- ✅ **Error messages** with icon
- ✅ **Password toggle** with eye icon
- ✅ **Exact design match** with proper colors
- ✅ **Production-ready** and reusable

**Use it everywhere in your app for consistent, beautiful forms!** 🚀
