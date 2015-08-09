// Copyright 2015, Austin Cummings, Chris Lucas, Michael Loveridge
// This file is part of oracle.dart, and is released under LGPL v3.

#pragma once

#include <dart_api.h>

void OracleMetadata_Finalizer(void * isolate_callback_data,
                              Dart_WeakPersistentHandle handle,
                              void* peer);
void OracleMetadata_getBoolean(Dart_NativeArguments arguments);
void OracleMetadata_getInt(Dart_NativeArguments arguments);
void OracleMetadata_getNumber(Dart_NativeArguments arguments);
void OracleMetadata_getString(Dart_NativeArguments arguments);
void OracleMetadata_getTimeStamp(Dart_NativeArguments arguments);
void OracleMetadata_getUInt(Dart_NativeArguments arguments);