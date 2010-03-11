module Hpricot
  class Name; include Hpricot end
  class Context; include Hpricot end

  # :stopdoc:
  module Tag; include Hpricot end
    class ETag; include Tag end
  # :startdoc:

  module Node; include Hpricot end
    class ETag; include Node end
    module Container; include Node end
      class Doc; include Container end
      class Elem; include Container end

    module Leaf; include Node end
      class CData; include Leaf end
      class Text; include Leaf end
      class XMLDecl; include Leaf end
      class DocType; include Leaf end
      class ProcIns; include Leaf end
      class Comment; include Leaf end
      class BogusETag; include Leaf end

  module Traverse end
  module Container::Trav; include Traverse end
  module Leaf::Trav; include Traverse end
  class Doc;       module Trav; include Container::Trav end; include Trav end
  class Elem;      module Trav; include Container::Trav end; include Trav end
  class CData;     module Trav; include Leaf::Trav      end; include Trav end
  class Text;      module Trav; include Leaf::Trav      end; include Trav end
  class XMLDecl;   module Trav; include Leaf::Trav      end; include Trav end
  class DocType;   module Trav; include Leaf::Trav      end; include Trav end
  class ProcIns;   module Trav; include Leaf::Trav      end; include Trav end
  class Comment;   module Trav; include Leaf::Trav      end; include Trav end
  class BogusETag; module Trav; include Leaf::Trav      end; include Trav end

  class Error < StandardError; end
end

