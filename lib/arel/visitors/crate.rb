module Arel
  module Visitors
    class Crate < Arel::Visitors::ToSql

      private
    end
  end
end

Arel::Visitors::VISITORS['crate'] = Arel::Visitors::Crate