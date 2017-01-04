# nl-json-rpc

# 简述
在工作情境中，常有需求，需要在A机上调用B机上的接口，而且调用的接口必须是可控的。所以才有了这个json－rpc。

这个json－rpc与http无关，只是实现一个server，用于提供可供远程调用的interface，并监听本地或远端client发出的调用请求。

参考json－rpc标准，也提供了本实现的json－rpc协议标准。

在这里，json只是作为数据交换的格式存在，实现则通过newlisp编写。由于newlisp本身有实现了由json－string向list表达式转换的操作(json-parse)，但是没有提供一个逆向操作，所以需要自行实现逆向操作，以便于数据的操作。 

被调用的interface可通过C以动态库的形式提供，也可以通过newlisp本身实现。最终通过newlisp的list的形式被组织，供server查询调用。
