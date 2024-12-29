#!/bin/bash

# Function to show a spinner for long-running processes
spinner() {
    local pid=$1
    local delay=0.2
    local spinstr='-\|/'  # Simple spinner symbols for wide compatibility
    while kill -0 $pid 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
    done
    printf "    \r"
}

# Display the current date and time for tracking
echo "Starting Homebrew Maintenance at $(date)"
echo "--------------------------------------------"

# Step 1: Audit the system for any issues
echo "Running brew doctor..."
brew doctor &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "System is healthy!"
else
    echo "Please address the issues listed above!"
    exit 1
fi

# Step 2: Clean up old versions of formulae and casks
echo "Cleaning up old versions of formulae and casks..."
brew cleanup -s &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "Cleanup complete!"
else
    echo "Error during cleanup. Exiting..."
    exit 1
fi

# Step 3: Check for outdated formulae and casks in parallel
echo "Checking for outdated formulae and casks..."
brew outdated --formula &
pid1=$!
brew outdated --cask &
pid2=$!
spinner $pid1
spinner $pid2
wait $pid1
wait $pid2

outdated_formulae=$(brew outdated --formula)
if [ -z "$outdated_formulae" ]; then
    echo "All formulae are up to date."
else
    echo "Outdated formulae:"
    echo "$outdated_formulae"
fi

outdated_casks=$(brew outdated --cask)
if [ -z "$outdated_casks" ]; then
    echo "All casks are up to date."
else
    echo "Outdated casks:"
    echo "$outdated_casks"
fi

# Step 4: Update Homebrew itself
echo "Updating Homebrew..."
brew update &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "Homebrew updated!"
else
    echo "Error during update. Exiting..."
    exit 1
fi

# Step 5: Upgrade all installed formulae in parallel
echo "Upgrading formulae..."
brew upgrade &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "Formulae upgraded!"
else
    echo "Error during formulae upgrade. Exiting..."
    exit 1
fi

# Step 6: Upgrade all installed casks with a progress bar for multiple upgrades
echo "Upgrading casks..."
casks=$(brew list --cask)
total_casks=$(echo "$casks" | wc -l)
counter=0
# Parallelize cask upgrades
for cask in $casks; do
    brew upgrade --cask $cask &
done
# Wait for all background cask upgrade processes to finish
wait
echo "Casks upgraded!"

# Step 7: Check for missing dependencies
echo "Checking for missing dependencies..."
brew missing &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "All dependencies are satisfied!"
else
    echo "Missing dependencies detected!"
    exit 1
fi

# Step 8: Remove any unnecessary dependencies (use with caution)
echo "Removing unused dependencies..."
brew autoremove &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "Unused dependencies removed!"
else
    echo "Error removing unused dependencies!"
    exit 1
fi

# Step 9: Final cleanup
echo "Performing final cleanup..."
brew cleanup -s &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "Final cleanup complete!"
else
    echo "Error during final cleanup!"
    exit 1
fi

# Step 10: Show disk usage (optional, helps identify large packages)
echo "Checking disk usage..."
brew list --formula --verbose | grep '/usr/local/Cellar' | xargs -I {} du -sh {} | sort -rh &
pid=$!
spinner $pid
wait $pid
echo "Disk usage checked."

# Step 11: Re-check the system after maintenance
echo "Re-running brew doctor after maintenance..."
brew doctor &
pid=$!
spinner $pid
wait $pid
if [ $? -eq 0 ]; then
    echo "System is healthy after maintenance!"
else
    echo "There are still issues to address."
    exit 1
fi

# End script with timestamp
echo "--------------------------------------------"
echo "Homebrew maintenance completed at $(date)"