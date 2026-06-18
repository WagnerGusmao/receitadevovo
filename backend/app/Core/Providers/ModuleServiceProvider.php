<?php

namespace App\Core\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Route;

class ModuleServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        $modulesPath = app_path('Modules');
        
        if (!is_dir($modulesPath)) {
            return;
        }

        // Define load priority to handle dependencies (e.g., Ecommerce depends on Wellness)
        $priority = ['Auth', 'Wellness', 'Ecommerce', 'Content'];
        $availableModules = array_map('basename', glob($modulesPath . '/*', GLOB_ONLYDIR));
        
        $modules = array_unique(array_merge(
            array_intersect($priority, $availableModules),
            $availableModules
        ));

        foreach ($modules as $module) {
            $this->loadModule($module);
        }
    }

    /**
     * Load a specific module.
     */
    private function loadModule(string $module): void
    {
        $modulePath = app_path("Modules/{$module}");

        // Load Routes
        if (file_exists("{$modulePath}/Routes/api.php")) {
            Route::middleware('api')
                ->prefix('api/' . strtolower($module))
                ->group("{$modulePath}/Routes/api.php");
        }

        if (file_exists("{$modulePath}/Routes/web.php")) {
            Route::middleware('web')
                ->group("{$modulePath}/Routes/web.php");
        }

        // Load Migrations
        if (is_dir("{$modulePath}/Database/Migrations")) {
            $this->loadMigrationsFrom("{$modulePath}/Database/Migrations");
        }

        // Load Views
        if (is_dir("{$modulePath}/Resources/views")) {
            $this->loadViewsFrom("{$modulePath}/Resources/views", strtolower($module));
        }
    }
}
