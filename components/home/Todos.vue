<script setup lang="ts">
defineProps({
  title: String,
  items: Array,
  id: Number
})
const emit = defineEmits(['deleteTodo', 'changeTodo']);
const deleteTodo = (id: Number) =>{
  emit('deleteTodo', id)
}
const changeTodo = (id: Nubmer) =>{
  emit('changeTodo', id)
}
</script>

<template>
  <div class="border border-cyan-700 rounded shadow-md w-9/12 mx-auto mt-5 mb-5 p-5">
    <div class="mb-3 flex justify-between">
      <h2 class="text-2xl md:text-4xl">{{ title }}</h2>
      <div class="text-end flex flex-col gap-2">
        <p
        @click="changeTodo"
        class="hover:text-blue-500 hover:underline cursor-pointer"
        >Изменить</p>
        <p class="hover:text-red-500 hover:underline cursor-pointer"
        @click="deleteTodo"
        >Удалить</p>
      </div>
    </div>
    <div class="flex flex-col md:flex-row md:justify-between md:items-end">
      <div class="flex flex-col">
      <span v-for="(item, index) in items.slice(0, 2)" :key="index">
        {{ item.task }} <span v-if="item.isChecked">✅</span><span v-if="!item.isChecked">❌</span>
      </span>
        <span v-if="items.length > 2" class="text-gray-400">
        ...и ещё {{ items.length - 2 }} задач
      </span>
      </div>
      <p class="text-gray-500">
        Выполнено: {{ items.filter(item => item.isChecked).length }}/{{ items.length }}
      </p>
    </div>

  </div>
</template>

<style scoped>

</style>
