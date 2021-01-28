<template>
	<div>
		<button @click="$emit('update:a',100)">修改父亲的aa</button>
		<button @click="$emit('abab',100)">修改父亲的bb</button>
		<!--默认插槽-->
		<slot></slot>
		<!--具名插槽-->
		<div>
			<slot name="a1" names="李四" :ages="18"></slot>
		</div>
		<div>
			<slot name="a2"></slot>
		</div>
		<div>
			<slot name="a2"></slot>
		</div>
		<div>
			<slot name="a4" names="张三" :ages="20" ></slot>
		</div>
	</div>
</template>

<script type="text/ecmascript-6">
        export default {
		name:"Demo",
	        props:["a","b"],
	        model:{
		        prop:"b",
		        event:"abab"
	        }
        };
</script>

<style lang="stylus" rel="stylesheet/stylus" scoped>

</style>