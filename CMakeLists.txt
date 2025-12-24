# Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license

# Collect all source files recursively
file(GLOB_RECURSE sources_ProgressionSystem 
    "${CMAKE_CURRENT_LIST_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_LIST_DIR}/src/*.h"
)

# Create source groups for IDE organization
source_group(TREE "${CMAKE_CURRENT_LIST_DIR}/src" FILES ${sources_ProgressionSystem})

# Add all sources to the worldserver
CU_ADD_HOOK(AFTER_WORLDSERVER_CMAKE
    "
    # Collect all source files from this module
    set(sources_ProgressionSystem
        ${sources_ProgressionSystem}
    )
    
    # Add sources to worldserver target
    target_sources(worldserver PRIVATE
        \${sources_ProgressionSystem}
    )
    
    CU_RUN_HOOK(ON_AFTER_LOAD_CONF)
    "
)

# Install configuration files
CU_ADD_HOOK(ON_INSTALL_CONFIGS
    "
    if(NOT EXISTS \"\${CMAKE_INSTALL_PREFIX}/etc/modules/progression_system.conf\")
        install(FILES \"\${CMAKE_CURRENT_LIST_DIR}/conf/progression_system.conf.dist\" DESTINATION \${CMAKE_INSTALL_PREFIX}/etc/modules)
    endif()
    "
)
