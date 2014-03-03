cmd_Release/magic.node := ln -f "Release/obj.target/magic.node" "Release/magic.node" 2>/dev/null || (rm -rf "Release/magic.node" && cp -af "Release/obj.target/magic.node" "Release/magic.node")
