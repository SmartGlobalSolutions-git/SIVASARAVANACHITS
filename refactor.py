import os
import re

files = [
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Home_Sections\home_screen.dart",
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Home_Sections\my_chits.dart",
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Home_Sections\my_chit_detail.dart",
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Prebitting\prebitting.dart",
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Home_Sections\need_help_screen.dart",
    r"c:\Users\sgsla\StudioProjects\siva_saravana\lib\Screens\Prebitting\prebid_detail.dart",
]

def replace_in_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Add shared prefs import if not present
    if "shared_prefs_helper.dart" not in content:
        content = re.sub(r"(import [^\n]+;\n)", r"\1import '../../services/shared_prefs_helper.dart';\n", content, count=1)

    # replace function body
    if "prebid_detail" in path:
        new_func = '''  Future<void> _fetchProfile() async {
    final name = await SharedPrefsHelper.getUserName();
    if (mounted && name.isNotEmpty) {
      setState(() {
        _bidderName = name;
      });
    }
  }'''
        content = re.sub(r"  Future<void> _fetchProfile\(\) async \{.*?\n  \}", new_func, content, flags=re.DOTALL)
    elif "need_help_screen" in path:
        new_func = '''  Future<void> _fetchUserName() async {
    final name = await SharedPrefsHelper.getUserName();
    if (mounted) {
      setState(() {
        _userName = name.isNotEmpty ? name : 'User';
      });
    }
  }'''
        content = re.sub(r"  Future<void> _fetchUserName\(\) async \{.*?\n  \}", new_func, content, flags=re.DOTALL)
    else:
        new_func = '''  Future<void> _fetchProfileName() async {
    final name = await SharedPrefsHelper.getUserName();
    if (mounted && name.isNotEmpty) {
      setState(() {
        _userName = name;
      });
    }
  }'''
        content = re.sub(r"  Future<void> _fetchProfileName\(\) async \{.*?\n  \}", new_func, content, flags=re.DOTALL)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

for f in files:
    try:
        replace_in_file(f)
        print(f"Processed {f}")
    except Exception as e:
        print(f"Error processing {f}: {e}")
print("Done")
