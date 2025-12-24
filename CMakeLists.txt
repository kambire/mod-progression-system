# Copyright (C) 2016+ AzerothCore <www.azerothcore.org>, released under GNU AGPL v3 license:
# https://github.com/azerothcore/azerothcore-wotlk/blob/master/LICENSE-AGPL3

CU_SET_PATH(MOD_PROGRESSION_BLIZZLIKE_SRC_DIR "${CMAKE_CURRENT_LIST_DIR}/src")

file(GLOB_RECURSE MOD_PROGRESSION_BLIZZLIKE_SOURCES
    "${MOD_PROGRESSION_BLIZZLIKE_SRC_DIR}/*.cpp"
)

AC_ADD_SCRIPT("${MOD_PROGRESSION_BLIZZLIKE_SOURCES}")

if (TARGET game)
    target_include_directories(game PRIVATE "${MOD_PROGRESSION_BLIZZLIKE_SRC_DIR}")
endif()
