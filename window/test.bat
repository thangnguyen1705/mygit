@echo on
for /d %%D in ("D:\prive\*") do echo %%~nxD && (
    For %%A in ("%%~fD\*") Do Echo:%%~nA && (
        echo %%~fA
    )
)
