ERMS contains a missing authorization vulnerability affecting administrative functionality.

The administrative endpoint admin/index.php checks only whether the PHP session contains a username:

```
if (!isset($_SESSION['username'])) {
    header('Location: .././index.php');
}
```
No authorization check is performed to verify whether the authenticated user has the administrator role.

As a result, an authenticated student account can directly access /admin/index.php and receive the administrative dashboard without having administrator privileges.

This breaks the intended privilege boundary between student and administrator accounts. The administrative area contains privileged student-management and other administrative functionality.

The issue was reproduced in a local deployment using a valid student account.

CWE-862: Missing Authorization.
