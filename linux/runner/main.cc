#include "my_application.h"

#include <iostream>
#include "battery/embed.hpp"

int main(int argc, char **argv)
{
  std::cout << "This is: \n"
            << b::embed<"test.txt">() << std::endl;
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
