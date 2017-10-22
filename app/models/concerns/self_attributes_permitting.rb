module SelfAttributesPermitting

  def permitted_attributes
    self.column_names.map(&:to_sym) - %i[id created_at updated_at]
  end

end