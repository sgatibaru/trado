trado.app =
{
    updatePrice: function(url, queryString, elem, elemTwo)
    {
        $(elem).change(function() 
        {
            var id, idTwo;
            id = $(this).val();
            idTwo = $(elemTwo).val();
            return $.get(url.concat(id, queryString, idTwo));
        });
    },

    jsonErrors: function() 
    {
        $(document).on("ajax:error", "form.remote-form", function(evt, xhr, status, error) 
        {
            var errors;
            errors = $.parseJSON(xhr.responseJSON.errors);
            $.each(errors, function(key, value) 
            {
                var $element, $errorTarget;
                $element = $("input[name*='" + key + "']");
                if ($element.length == 0)
                {
                    $element =  $("select[name*='" + key + "']");
                }
                $errorTarget = '.error-explanation';
                if ($element.parent().next().is($errorTarget)) 
                {
                    return $($errorTarget).html('<span>' + key + '</span> ' + value);
                } 
                else 
                {
                    $element.wrap('<div class="field-with-errors"></div>');
                    return $element.parent().after('<span class="' + $errorTarget.split('.').join('') + '"><span>' + key + '</span> ' + value + '</span>');
                }
            });
        });
    },

    typeahead: function() 
    {
        $("#navSearchInput").typeahead(
        {
            remote: "/search/autocomplete?utf8=✓&query=%QUERY",
            template: " <div class='inner-suggest'> <img src='{{image.file.url}}' height='45' width='45'/> <span> <div>{{value}}</div> <div>{{category_name}}{{}}</div> </span> </div>",
            engine: Hogan,
            limit: 4
        }).on("typeahead:selected", function($e, data) 
        {
            return window.location = "/categories/" + data.category_slug + "/products/" + data.product_slug;
        });
    },

    duplicateAddress: function() 
    {
        $('.use-billing-address').change(function() 
        {
            if (this.checked) 
            {
                $('.use-billing').each(function() 
                {
                    return $(this).val($(this).next('div').text());
                });
                $('.field_with_errors').each(function() 
                {
                    return $(this).children('input').val($(this).next('div').text());
                });
            } 
            else 
            {
                return $('.use-billing').val('');
            }
        });
    },

    selectShipping: function() 
    {
        $('.shipping-methods .option').click(function() 
        {
            $(this).find('input:radio').prop('checked', true);
            $('.option').removeClass('active');
            return $(this).addClass('active');
        });
        $('.shipping-methods .option input:radio').each(function() 
        {
            if ($(this).is(':checked')) 
            {
                return $(this).parent().addClass('active');
            }
        });
    },

    updateShipping: function()
    {
        $('.update-shipping select').change(function() 
        {
            if (this.value !== "") 
            {
                $.ajax('/order/shippings/update', 
                {
                    type: 'GET',
                    data: 
                    {
                        'country_id': this.value
                    },
                    dataType: 'html',
                    success: function(data) 
                    {
                        return $('.shipping-methods .control-group .controls').html(data);
                    }
                });
            } 
            else 
            {
                return $('.shipping-methods .control-group .controls').html('<p class="shipping_notice">Select a shipping country to view the available shipping options.</p>');
            }
        });
    }
}