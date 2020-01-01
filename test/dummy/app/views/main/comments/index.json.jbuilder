# frozen_string_literal: true

json.array! @comments, partial: 'main/comments/comment', as: :comment
