# create_structure.ps1
# Creates the folder and file structure for a GetX + SQLite expense tracker.
# Safe by default: existing files are NOT overwritten.

$ErrorActionPreference = "Stop"

$folders = @(
    "lib",
    "lib\core\theme",
    "lib\core\constants",
    "lib\core\utils",
    "lib\data\models",
    "lib\data\local",
    "lib\features\dashboard\controllers",
    "lib\features\dashboard\screens",
    "lib\features\dashboard\widgets",
    "lib\features\expenses\controllers",
    "lib\features\expenses\screens",
    "lib\features\expenses\widgets",
    "lib\features\settings\controllers",
    "lib\features\settings\screens",
    "lib\routes",
    "lib\bindings"
)

$files = @(
    "lib\main.dart",
    "lib\app.dart",

    "lib\core\theme\app_theme.dart",
    "lib\core\constants\app_constants.dart",
    "lib\core\utils\date_utils.dart",
    "lib\core\utils\money_utils.dart",
    "lib\core\utils\validators.dart",

    "lib\data\models\expense.dart",
    "lib\data\models\expense_category.dart",
    "lib\data\local\app_database.dart",
    "lib\data\local\expense_dao.dart",
    "lib\data\local\settings_storage.dart",

    "lib\features\dashboard\controllers\dashboard_controller.dart",
    "lib\features\dashboard\screens\dashboard_screen.dart",
    "lib\features\dashboard\widgets\month_selector.dart",
    "lib\features\dashboard\widgets\summary_card.dart",
    "lib\features\dashboard\widgets\category_breakdown.dart",
    "lib\features\dashboard\widgets\recent_transactions.dart",

    "lib\features\expenses\controllers\expense_form_controller.dart",
    "lib\features\expenses\controllers\transactions_controller.dart",
    "lib\features\expenses\screens\add_edit_expense_screen.dart",
    "lib\features\expenses\screens\transactions_screen.dart",
    "lib\features\expenses\widgets\expense_tile.dart",
    "lib\features\expenses\widgets\category_selector.dart",
    "lib\features\expenses\widgets\amount_field.dart",

    "lib\features\settings\controllers\settings_controller.dart",
    "lib\features\settings\screens\settings_screen.dart",

    "lib\routes\app_pages.dart",
    "lib\routes\app_routes.dart",

    "lib\bindings\initial_binding.dart",

    "test\expense_controller_test.dart"
)

Write-Host "Creating folders..." -ForegroundColor Cyan

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -Path $folder -ItemType Directory -Force | Out-Null
        Write-Host "Created folder: $folder"
    }
    else {
        Write-Host "Folder already exists: $folder" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Creating Dart files..." -ForegroundColor Cyan

foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        New-Item -Path $file -ItemType File -Force | Out-Null
        Write-Host "Created file: $file"
    }
    else {
        Write-Host "File already exists, skipped: $file" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Structure created successfully." -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "  flutter pub add get sqflite path intl shared_preferences fl_chart"
Write-Host "  flutter pub get"