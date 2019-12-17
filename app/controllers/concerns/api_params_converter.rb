module ApiParamsConverter
  def api_params(_params, keys)
    _params.permit(keys)

    # for camel case parameter
#     _params.permit(keys.map {|k|
#       case k
#       when Hash
#         k.deep_transform_keys {|k| k.to_s.camelize(:lower) }
#       when Array
#         k.map {|k| k.to_s.camelize(:lower) }
#       else
#         k.to_s.camelize(:lower)
#       end
#     }).to_h.deep_transform_keys(&:underscore)
  end
end
