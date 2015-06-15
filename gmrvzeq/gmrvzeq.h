#ifndef GMRV_ZEQ_VOCABULARY_H
#define GMRV_ZEQ_VOCABULARY_H

#include <zeq/types.h>
#include <zeq/api.h>

#include <gmrvzeq/focus_zeq_generated.h>

#include <vector>

namespace zeq
{
  namespace gmrv
  {
    ZEQ_API
    Event serializeFocusedIDs( const std::vector< unsigned int >& ids );

    ZEQ_API
    std::vector< unsigned int > deserializeFocusedIDs( const Event& event );
  }
}
#endif
