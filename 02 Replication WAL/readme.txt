Сложность задачи - реплицирование происходит между Windows и Ubuntu,
в официальной документации по этому поводу есть только рекомендации, что системы должны быть одинаковые.
Практика показала, что можно настроить - см. файл с инструкцией по кофигурированию.

Составные части задачи:

1) archive command на основном сервере (Windows)

archive_command =  '"C:\\Program Files\\7-zip\\7z.exe" -ssw -mx9 a "E:\\LM\\WAL\\%f.7z" "%p"'

2) restore command на сервере-реплике (Ubuntu)

restore_command = '7za x -so /mnt/hgfs/SF/WAL/%f.7z > %p'
archive_cleanup_command='pg_archivecleanup -d -x .7z /mnt/hgfs/SF/WAL %r'

7zip - для уменьшения места хранения и трафика, реплицирование происходит на удаленную систему по небольшому каналу

