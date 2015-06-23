#include <iostream>

#include <zeq/zeq.h>
#include <lunchbox/uri.h>

#include <gmrvzeq.h>
#include <ctime>

#define NUM_SELECTIONS 100

void delay( unsigned int delay_ )
{
  std::clock_t starTime = std::clock( );
  bool endTime = false;

  while( !endTime )
  {
    endTime = (( std::clock( ) - starTime ) * 1000 / CLOCKS_PER_SEC ) >= delay_;
  }

}

int main( int argc, char * argv[] )
{
  if ( argc < 2 )
    return -1;

  lunchbox::URI uri( argv[1] );

  zeq::Publisher publisher( uri );

  std::vector< unsigned int > data;

  for ( unsigned int i = 0; i < NUM_SELECTIONS; i++ )
  {
    data.push_back( i );
    publisher.publish( zeq::gmrv::serializeFocusedIDs( data ));
    std::cout << "Send FocusedIDs Event" << std::endl;
    delay( 1000 );
  }

  return 0;
}